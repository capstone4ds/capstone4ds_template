**Diabetes Prediction Project using Bayesian Logistic Regression** 

#Bayesian Logistic Regression: Predicting Diabetes Probability

**Capstone Project (2025)**
**Author:** Namita Mishra (Advisor: Dr. Ashraf Cohen)
**Date:** October 2025
---

Project Overview

* Diabetes Mellitus (DM) is a chronic metabolic disease characterized by elevated blood glucose levels, leading to serious damage to the heart, blood vessels, eyes, kidneys, and nerves over time. Early detection is crucial for prevention and control.
* This project applies **Bayesian Logistic Regression** and **Survey-weighted Maximum Likelihood Estimation (MLE)** to predict diabetes probability using national-level survey data.
---

## **Dataset** National Health and Nutrition Examination Survey (NHANES)

**Cycle:** 2013–2014
**Sample:** U.S. adults (≥20 years)
**Variables Used:**

  * `DIQ010`: Doctor told you have diabetes
  * `RIDAGEYR`: Age in years
  * `BMDBMIC`: Body Mass Index (BMI)
  * `RIAGENDR`: Gender
  * `RIDRETH1`: Race/Ethnicity
  * `WTMEC2YR`: Sampling weights
  * `SDMVPSU`, `SDMVSTRA`: Design variables

    Data were preprocessed, cleaned, and subset to adults with complete anthropometric and questionnaire data.
---

## Methods

### 1 Data Preprocessing

* Missing values were handled using **multiple imputation** (`mice` package).
* Variables were recoded and centered for interpretability.
* Survey weights were normalized for Bayesian modeling.

### 2️ Statistical Models

#### **A. Survey-weighted MLE**

* Implemented using `svyglm()` from the **survey** package.
* Correctly accounted for NHANES’s complex sampling design.

#### **B. Bayesian Logistic Regression**

* Implemented using `brms` (Bayesian Regression Models via Stan).
* Priors: Weakly informative (`Normal(0, 2)` for coefficients).
* Computation: 4 chains × 2000 iterations (1000 warmup).
* Normalized sampling weights were used as **importance weights**, approximating the design effect.

### 3️ Model Diagnostics

* Convergence checked via `Rhat < 1.01`, trace plots.
* Predictive accuracy evaluated using **LOOIC** and **Posterior Predictive Checks (PPC)**.
* Comparison made with survey-weighted MLE results.
---

## Results Summary

| Variable               | MLE Estimate (OR) | Bayesian Mean (OR) | 95% CI (Bayesian) |
| ---------------------- | ----------------: | -----------------: | ----------------: |
| **Age**                |   ↑ 1.07 per year |             ↑ 1.06 |      [1.05, 1.08] |
| **BMI**                |   ↑ 1.09 per unit |             ↑ 1.08 |      [1.07, 1.10] |
| **Male**               |            ↑ 1.22 |             ↑ 1.18 |      [1.05, 1.33] |
| **Non-Hispanic Black** |            ↑ 1.45 |             ↑ 1.38 |      [1.20, 1.59] |

* Both models identified **age**, **BMI**, and **race/ethnicity** as strong predictors of diabetes.
* The Bayesian model produced smoother posterior distributions and credible intervals reflecting parameter uncertainty.
---

## Design Considerations
**Survey-weighted MLE** directly modeled NHANES’s complex design (strata, PSU, and weights).
**Bayesian model** applied normalized sampling weights as **importance weights**, approximating design effects but not fully modeling them.
Hence, Bayesian results are **model-based** (conditional on data and priors) rather than **population-weighted** estimates.

---

## Key Insights

* Bayesian logistic regression provides **probabilistic predictions** and **uncertainty quantification**, valuable in public health decision-making.
* Integration of design weights in Bayesian models remains an active research area, bridging population inference and model-based prediction.
---

## Tools and Packages

* **R (v4.3+)**

    * `tidyverse`, `survey`, `brms`, `mice`, `bayesplot`, `loo`, `ggplot2`
    * **Bayesian computation:** Stan backend
    * **Visualization:** Posterior intervals, trace plots, PPC plots
---

## File Structure

```
├── data/
│   └── nhanes_diabetes.sas7bdat
├── scripts/
│   ├── 01_data_cleaning.R
│   ├── 02_mle_model.R
│   ├── 03_bayesian_model.R
│   └── 04_ppc_diagnostics.R
├── results/
│   ├── model_summary.csv
│   ├── posterior_plots.png
│   └── diagnostics/
└── README.md
```
---

## Future Directions

* Extend model to **hierarchical Bayesian structure** incorporating time-series NHANES data.
* Explore **Bayesian survey integration** via pseudo-likelihood or rstanarm’s survey module.
* Compare predictive performance using cross-validation and external datasets.
---

## Acknowledgments
* Special thanks to **Dr. Ashraf Cohen** for mentorship and guidance, and to the **NHANES program** for providing high-quality public data for epidemiological research.
---

## References

* NHANES (CDC). *National Health and Nutrition Examination Survey Data.*
* Gelman, A., et al. (2020). *Bayesian Data Analysis.*
* Lumley, T. (2010). *Complex Surveys: A Guide to Analysis Using R.*
* Bürkner, P.-C. (2017). *brms: An R package for Bayesian multilevel models using Stan.*
---


