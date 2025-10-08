# ---------------------- Load packages ----------------------
options(repos = c(CRAN = "https://cloud.r-project.org"))
library(nhanesA)
library(tidyverse)
library(forcats)
library(survey)
library(mice)
library(brms)
library(posterior)
library(knitr)

# ---------------------- Import NHANES data ----------------------
bmx_h  <- nhanes("BMX_H")
demo_h <- nhanes("DEMO_H")
diq_h  <- nhanes("DIQ_H")

# ---------------------- Select variables ----------------------
exam_sub <- bmx_h  %>% select(SEQN, BMXBMI)
need_demo <- c("SEQN","RIDAGEYR","RIAGENDR","RIDRETH1","SDMVPSU","SDMVSTRA","WTMEC2YR")
demo_sub <- demo_h %>% select(all_of(need_demo))
diq_sub  <- diq_h %>% select(SEQN, DIQ010, dplyr::any_of("DIQ050"))

# ---------------------- Merge datasets ----------------------
merged_data <- demo_sub %>%
  left_join(exam_sub, by = "SEQN") %>%
  left_join(diq_sub,  by = "SEQN")

# ---------------------- Convert/clean variables ----------------------
to_num <- function(x) {
  if (is.numeric(x)) return(x)
  xc <- as.character(x)
  n <- suppressWarnings(readr::parse_number(xc))
  if (mean(is.na(n)) > 0.8) {
    xlow <- tolower(trimws(xc))
    n <- dplyr::case_when(
      xlow %in% c("1","yes","yes, told") ~ 1,
      xlow %in% c("2","no","no, not told") ~ 2,
      xlow %in% c("3","borderline") ~ 3,
      xlow %in% c("7","refused") ~ 7,
      xlow %in% c("9","don't know","dont know","unknown") ~ 9,
      TRUE ~ NA_real_
    )
  }
  as.numeric(n)
}

merged_data <- merged_data %>%
  mutate(
    DIQ010   = to_num(DIQ010),
    DIQ050   = to_num(if (!"DIQ050" %in% names(.)) NA_real_ else DIQ050),
    BMXBMI   = as.numeric(BMXBMI),
    RIDAGEYR = as.numeric(RIDAGEYR),
    RIAGENDR = as.numeric(RIAGENDR),
    RIDRETH1 = as.numeric(RIDRETH1),
    SDMVPSU  = as.numeric(SDMVPSU),
    SDMVSTRA = as.numeric(SDMVSTRA),
    WTMEC2YR = as.numeric(WTMEC2YR)
  )

# ---------------------- Filter adults and create analysis variables ----------------------
adult <- merged_data %>%
  filter(RIDAGEYR >= 20) %>%
  transmute(
    SDMVPSU, SDMVSTRA, WTMEC2YR,
    diabetes_dx = case_when(
      DIQ010 == 1 ~ 1,
      DIQ010 == 2 ~ 0,
      DIQ010 %in% c(3,7,9) ~ NA_real_
    ),
    bmi  = BMXBMI,
    age  = RIDAGEYR,
    sex  = fct_recode(factor(RIAGENDR), Male="1", Female="2"),
    race = fct_recode(factor(RIDRETH1),
                      "Mexican American"="1",
                      "Other Hispanic"="2",
                      "NH White"="3",
                      "NH Black"="4",
                      "Other/Multi"="5"),
    DIQ050 = DIQ050
  ) %>%
  mutate(
    age_c = as.numeric(scale(age)),
    bmi_c = as.numeric(scale(bmi)),
    bmi_cat = cut(bmi, breaks = c(-Inf,18.5,25,30,35,40,Inf),
                  labels=c("<18.5","18.5–<25","25–<30","30–<35","35–<40","≥40"), right=FALSE),
    diabetes_dx = ifelse(sex=="Female" & !is.na(DIQ050) & DIQ050==1, 0, diabetes_dx)
  ) %>%
  mutate(race = fct_relevel(race, "NH White"))

# ---------------------- Survey design ----------------------
nhanes_design_adult <- svydesign(
  id = ~SDMVPSU,
  strata = ~SDMVSTRA,
  weights = ~WTMEC2YR,
  nest = TRUE,
  data = adult
)

# ---------------------- Survey-weighted logistic regression ----------------------
keep_cc <- with(adult, !is.na(diabetes_dx) & !is.na(age_c) & !is.na(bmi_c) &
                  !is.na(sex) & !is.na(race))
des_cc <- subset(nhanes_design_adult, keep_cc)
form_cc <- diabetes_dx ~ age_c + bmi_c + sex + race
svy_fit <- svyglm(formula = form_cc, design = des_cc, family = quasibinomial())
svy_or <- broom::tidy(svy_fit, conf.int=TRUE) %>%
  mutate(OR=exp(estimate), LCL=exp(conf.low), UCL=exp(conf.high)) %>%
  filter(term != "(Intercept)") %>%
  select(term, OR, LCL, UCL, p.value)

# ---------------------- Multiple Imputation ----------------------
mi_dat <- adult %>% select(diabetes_dx, age, bmi, sex, race, WTMEC2YR, SDMVPSU, SDMVSTRA)
meth <- make.method(mi_dat)
pred <- make.predictorMatrix(mi_dat)
meth["diabetes_dx"] <- ""
pred["diabetes_dx", ] <- 0
meth["age"] <- "norm"
meth["bmi"] <- "pmm"
meth["sex"] <- "polyreg"
meth["race"] <- "polyreg"
imp <- mice(mi_dat, m=5, method=meth, predictorMatrix=pred, seed=123)
fit_mi <- with(imp, {
  age_c <- scale(age)
  bmi_c <- scale(bmi)
  glm(diabetes_dx ~ age_c + bmi_c + sex + race, family=binomial())
})
pool_mi <- pool(fit_mi)
mi_or <- summary(pool_mi, conf.int=TRUE, exponentiate=TRUE) %>%
  filter(term != "(Intercept)")

# ---------------------- Bayesian Logistic Regression ----------------------
adult_imp1 <- complete(imp, 1) %>%
  mutate(
    age_c = scale(age),
    bmi_c = scale(bmi),
    wt_norm = WTMEC2YR / mean(WTMEC2YR, na.rm=TRUE),
    race = fct_relevel(race, "NH White"),
    sex  = fct_relevel(sex, "Male")
  ) %>%
  filter(!is.na(diabetes_dx), !is.na(age_c), !is.na(bmi_c),
         !is.na(sex), !is.na(race)) %>% droplevels()

priors <- c(
  set_prior("normal(0, 2.5)", class="b"),
  set_prior("student_t(3, 0, 10)", class="Intercept")
)

bayes_fit <- brm(
  formula = diabetes_dx | weights(wt_norm) ~ age_c + bmi_c + sex + race,
  data = adult_imp1,
  family = bernoulli(link="logit"),
  prior = priors,
  chains = 4, iter = 2000, seed = 123,
  control = list(adapt_delta=0.95),
  refresh = 0
)

bayes_or <- posterior_summary(bayes_fit, pars="^b_") %>%
  as.data.frame() %>%
  tibble::rownames_to_column("raw") %>%
  mutate(
    term = gsub("^b_", "", raw),
    term = gsub("race", "race:", term),
    term = gsub("sex", "sex:", term),
    OR = exp(Estimate),
    LCL = exp(Q2.5),
    UCL = exp(Q97.5)
  ) %>%
  filter(term != "Intercept") %>%
  select(term, OR, LCL, UCL)

# ---------------------- Save results ----------------------
dir.create("outputs", showWarnings = FALSE)
saveRDS(svy_fit, "outputs/svy_fit.rds")
saveRDS(pool_mi, "outputs/pool_mi.rds")
saveRDS(bayes_fit, "outputs/bayes_fit.rds")
saveRDS(svy_or, "outputs/survey_OR_table.rds")
saveRDS(mi_or, "outputs/mi_OR_table.rds")
saveRDS(bayes_or, "outputs/bayes_OR_table.rds")
