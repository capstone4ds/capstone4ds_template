install.packages("nhanesA")
library ("nhanesA")



nhanesTables('EXAM', 2013)
nhanesTables('DIETARY', 2013)
nhanesTables('LAB', 2013)
nhanesTables('QUESTIONNAIRE', 2013)
nhanesTables('DEMOGRAPHICS', 2013)


nhanesCodebook("DEMO_H")
nhanesCodebook("DIQ_H")
nhanesCodebook("SMQ_H")
nhanesCodebook("BMX_H")

                DEMO_H.xpt
               DSQTOT_H.xpt
               BMX_H.xpt
               TCHOL_H.xpt
               CDQ_H.xpt
               SMQ_H.xpt
               MCQ_H.xpt
               DIQ_H.xpt

               mcq_h <- nhanes("MCQ_H")   # example: load Medical Conditions file for 2013–2014
               cdq_h <- nhanes("CDQ_H")
               bmx_h <- nhanes("BMX_H")
               dsqtot_h <- nhanes("DSQTOT_H")
               tchol_h <- nhanes("TCHOL_H")
               demo_h <- nhanes("DEMO_H")
               diq_h <- nhanes("DIQ_H")
              
               
               glimpse(demo_h)
               head(demo_h) 
               tail(demo_h)
               summary(demo_h)
               
               
               
               glimpse(dsqtot_h)
               head(dsqtot_h) 
               tail(dsqtot_h)
               summary(dsqtot_h) 
               
               
               
               glimpse(mcq_h)
               head(mcq_h) 
               tail(mcq_h)
               summary(mcq_h)
               
               glimpse(cdq_h)
               head(cdq_h) 
               tail(cdq_h)
               summary(cdq_h)
               
               
               glimpse(bmx_h)
               head(bmx_h) 
               tail(bmx_h)
               summary(bmx_h)
               
               
               glimpse(tchol_h)
               head(tchol_h) 
               tail(tchol_h)
               summary(tchol_h)
               
               ## Variable names 
               names(tchol_h)           
               
               
               ## Explore data
               arrange(tchol_h) 
               filter()
               select()
               mutate()
               summarise() 
               
               
             
         # mcq_h
               
               vars <- c("MCQ160C","MCQ160D","MCQ160E","MCQ160F","MCQ160B")
               vars <- vars[vars %in% names(mcq_h)]
               
               #  ("MCQ160C","MCQ160D","MCQ160E","MCQ160F","MCQ160B")
               
                       summary (mcq_h$MCQ160B)
                       summary (mcq_h$MCQ160C)
                       summary (mcq_h$MCQ160D)
                       summary (mcq_h$MCQ160E)
                       summary (mcq_h$MCQ160F)
                      
                       
                       
                       vars <- intersect(c("MCQ160C","MCQ160D","MCQ160E","MCQ160F","MCQ160B"), names(mcq_h))
                       
                       convert_mcq_base <- function(x) {
                         if (is.factor(x)) x <- as.character(x)
                         out <- ifelse(grepl("^[0-9]", x),
                                       as.integer(sub("^([0-9]+).*", "\\1", x)),
                                       ifelse(x %in% c("Yes","YES","yes","1"), 1L,
                                              ifelse(x %in% c("No","NO","no","2"), 2L,
                                                     ifelse(x %in% c("Refused","7"), 7L,
                                                            ifelse(x %in% c("Don't know","Don’t know","9","DK","Unknown"), 9L, as.integer(x))))))
                         out[out %in% c(7L,9L)] <- NA_integer_
                         out
                       }
                       
                       mcq_h[vars] <- lapply(mcq_h[vars], convert_mcq_base)
                       
                       mcq_h$CVD_status <- as.integer(rowSums(mcq_h[vars] == 1L, na.rm = TRUE) > 0)
                       table(mcq_h$CVD_status, useNA = "ifany")
                       
                    
                   
      
       # new mcq_h # CVD output
                       
                      mcq_h$CVD_status_f <- factor(mcq_h$CVD_status, levels = c(0, 1), labels = c("No CVD", "CVD"))
                       
                     
                       mcq_h$CVD_status_f ## outcome ## 
                       
                       # counts and percents in a tidy data frame
                       tab_counts <- table(mcq_h$CVD_status_f, useNA = "ifany")
                       tab_counts
                       
                       
                       
                        # tab_df <- data.frame(
                         #variable = vars,
                         #n_na    = colSums(is.na(mcq_h[vars])),
                         #n_nonNA = colSums(!is.na(mcq_h[vars])),
                         #pct_na  = round(colMeans(is.na(mcq_h[vars])) * 100, 1),
                         #stringsAsFactors = FALSE)
                       
                       # tab_df
                       
                       
                       
                       ## mcq_h        summary(mcq_h)
                       glimpse(mcq_h$CVD_status_f)
                       summary(mcq_h$CVD_status_f)
                      table(mcq_h$CVD_status_f) 
                       
                       
                       # Combine tables into a data frame
                       #common_freq_mcq <- data.frame(
                         
                       #common_freq_mcq
                       
                       
                       #unique(new_mcq_h$MCQ160B)
                       

                       
                       library(Hmisc)
                       describe(mcq_h$CVD_status_f)
                       
                       describe(common_freq_mcq)
                       
                       sum(is.na(mcq_h$CVD_status_f)) 
                    
              
                       
       # tchol #   lab               
                         
                     arrange(tchol_h)%>% group_by(LBDTCSI)%>% count(LBDTCSI)
                     
                     arrange(tchol_h)%>% group_by(LBDTCSI)%>% count(LBDTCSI)%>%
                       arrange(desc(LBDTCSI))
                
                    
      # new tchol # lab
                                   new_tchol_h <- tchol_h %>%
                    select(LBDTCSI)
                    
                     new_tchol_h
                     new_tchol_h$LBDTCSI
                     hist(new_tchol_h$LBDTCSI)
                     
                     T1 <- new_tchol_h %>%
                       filter(LBDTCSI < 8)
                     
                     hist(new_tchol_h$LBDTCSI)
                     hist(T1)
                     
              
                
                   
       #demo#        
                     summary(demo_h)
                     summary (demo_h$RIDAGEYR)
                     demo_h
                     
                     demo_h$RIDRETH1
                     
                     names(demo_h)
                     new_demo_h <- demo_h %>%
                       select("RIDAGEYR","RIAGENDR", "RIDRETH1")
                     
       # new demo
                     new_demo_h
                     hist(new_demo_h$RIDAGEYR)    #age
              
                    freq1 <- table(as.factor(demo_h$RIDRETH1))  #ethnicity
                     freq1
                     hist(freq1)
                 
                     freq2 <- table(as.factor(demo_h$RIAGENDR)) # sex
                     freq2
                     hist(freq2)
                     
                     
                    barplot(freq1,
                                  main = "Ethnicity",
                                  xlab = "RIDRETH1",
                                  ylab = "Count",
                                  col = "skyblue")
                    
                    barplot(freq2,
                            main = "sex",
                            xlab = "RIAGENDR",
                            ylab = "Count",
                            col = "skyblue")
                    
                      hist(demo_h$RIDAGEYR)           # for numeric variable only##
                   
                
  #losing 40% of your sample → possible bias if missing is not random.  
                    
                    
library(dplyr)
library(tidyr)
library(forcats)
library(ggplot2)
                    
 
                      
          # missing # new_mcq_h          
                     
                      sum(is.na(mcq_h$CVD_status ))
                      
                      table(mcq_h$CVD_status )
                     
                   
                      
          # Demo missing
                      
                      new_demo_h
                      sum(is.na(new_demo_h))
                      freq1
                      
                     
                      barplot(freq1,
                             main = "Distribution of Etnicity",
                             xlab = "Etnicity",
                             ylab = "Count",
                             col = "skyblue",
                             border = "black")
                      
                      barplot(freq2,
                              main = "Distribution of sex",
                              xlab = "Sex",
                              ylab = "Count",
                              col = "skyblue",
                              border = "black")

                      hist(new_demo_h$RIDAGEYR)                      
                      
                     
      # age group cretad and (RIDAGEYR with NAs)
                      
                    
                      # handles ages <10 or missing
                      
                      new_demo_h <- new_demo_h %>%
                        mutate(AgeGroup = case_when(
                          !is.na(RIDAGEYR) & RIDAGEYR >= 10  & RIDAGEYR <= 20 ~ "10-20",
                          !is.na(RIDAGEYR) & RIDAGEYR >= 21  & RIDAGEYR <= 40 ~ "21-40",
                          !is.na(RIDAGEYR) & RIDAGEYR >= 41  & RIDAGEYR <= 60 ~ "41-60",
                          !is.na(RIDAGEYR) & RIDAGEYR > 60                   ~ ">60",
                          TRUE                                               ~ "Other/Unknown"  
                        ))
                      
                      new_demo_h$AgeGroup
                      
                      table_age_group <- table(new_demo_h$AgeGroup)
                      table_age_group
                      
                      barplot((table_age_group),
                              main = "Distribution of age group",
                              xlab = "age groups",
                              ylab = "Count",
                              col = "skyblue",
                              border = "black")
                      
                     
                       str(new_demo_h)
                       
                       sum(is.na(new_demo_h))
                       sum( is.na(demo_h$RIDAGEYR))
                       sum( is.na(demo_h$RIAGENDR))
                       sum( is.na(demo_h$RIDRETH1))
                       colSums(is.na(new_demo_h))
                       
                       sum(is.na(new_tchol_h))  
                       
          
                        
                        
                        
                       
                       
                       
                      