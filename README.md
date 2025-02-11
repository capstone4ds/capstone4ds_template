Literature Review:
Literature Review

This project aims to predict trial exhaustion rates and joint injury risks using biomechanical data alongside simulated physiological metrics. The work builds upon established methods in sports science and biomechanics while incorporating modern data science techniques such as feature engineering, temporal modeling, and ensemble methods. The project is structured into two main pipelines—regression and classification—each targeting different predictive goals based on a comprehensive set of features derived from trial-level data.

Data Loading and Preprocessing

The project begins by merging a CSV dataset containing trial-level measurements (e.g., joint energy and joint power) with participant information using unique identifiers (such as trial_id and player_participant_id). Extensive data cleaning—such as imputing or dropping missing values—is conducted with logging and debugging functions to ensure data integrity.

Feature Engineering

A critical component of this project is the derivation of new features that capture both biomechanical outputs and simulated physiological states:

    Joint Metrics:
    Aggregated values for joint energy and joint power are calculated by summing measurements across multiple joints. These serve as primary indicators of physical output.

    Simulated Physiological Measures:
    A simulated heart rate is computed as a function of mean energy and joint energy, acting as a proxy for physiological stress. Additionally, “fake body” metrics (including sleep quality, sleep duration, resting heart rate, heart rate variability, and stress index) are introduced to simulate wearable data that may influence fatigue and injury risk.

    Temporal Dynamics:
    Lag features (e.g., exhaustion from the previous trial) and rolling statistics (such as moving averages and volatility measures) are computed to capture trends and variability across trials. The trial exhaustion rate is then calculated as the change in exhaustion score per trial.

    Asymmetry Features:
    Differences between left and right joint metrics are measured to identify potential imbalances that could lead to injury.

Workout Simulation

A novel aspect of the project is the simulation of two workouts. The first workout consists of the original 125 trials, while the second is a duplicate that simulates gradual deterioration in the fake body metrics (e.g., reduced sleep quality, increased resting heart rate). These are distinguished by adding a workout_id and a trial counter, and then concatenated into a single dataset to enable downstream analysis.

Pipeline 1: Regression for Predicting Trial Exhaustion Rate

The first pipeline focuses on forecasting the trial exhaustion rate, defined as the change in exhaustion per trial. Input features include:

    Aggregated Joint Metrics: Joint energy and power sums.
    Simulated Physiological Features: Simulated heart rate and fake body metrics.
    Temporal Features: Lag features (e.g., previous trial exhaustion) and rolling averages (e.g., five-trial moving averages) capturing trends and volatility.

A baseline linear regression model is used initially, with the potential to progress to more complex models such as Random Forests, Gradient Boosting, or LSTM networks. Evaluation metrics include MAE, RMSE, and R², with visualizations comparing predicted and actual values over time.

Pipeline 2: Classification for Predicting Joint Injury Risk

The second pipeline targets the prediction of injury risk for specific joints using a classification approach. Here, the key features are:

    Joint-Specific Metrics: Measurements from individual joints (e.g., energy and power for the left ankle or right elbow).
    Asymmetry and Rolling Features: Calculated differences between bilateral joint metrics and cumulative load measures that capture stress over multiple trials.
    Simulated Physiological Features and Temporal Indicators: Fake body metrics and lag features similar to the regression pipeline.

Injury risk is determined by labeling trials based on whether a rolling sum of joint stress exceeds a predefined threshold (e.g., the 75th percentile). The modeling starts with logistic regression or decision trees and may evolve to more advanced classifiers like Random Forests or neural network-based methods. Evaluation is conducted using accuracy, precision, recall, F1-score, and ROC-AUC, supplemented by feature importance analysis (e.g., via SHAP).

Integration and Modularity

Both pipelines share common preprocessing and feature engineering modules, ensuring modularity and facilitating debugging and iterative improvements. Visualization tools such as histograms, correlation matrices, and temporal trend plots are employed to validate each step of the data transformation process.

Conclusion

This capstone project integrates biomechanical data with simulated physiological metrics to predict both trial exhaustion and joint injury risks. By leveraging temporal features, asymmetry measures, and innovative workout simulation, the project not only establishes robust predictive models but also contributes valuable insights to the literature on performance analytics in sports and rehabilitation. The modular, iterative approach ensures that each component—from data preprocessing to model evaluation—is transparent, reproducible, and adaptable for future research.


------------------------------------------------------------------------------------------------------------------------------




Links so far:
https://www.datacamp.com/tutorial/introduction-to-shap-values-machine-learning-interpretability

Links to an external site.

 

https://www.datacamp.com/tutorial/mastering-bayesian-optimization-in-data-science?utm_source=google&utm_medium=paid_search&utm_campaignid=19589720830&utm_adgroupid=157098107935&utm_device=c&utm_keyword=&utm_matchtype=&utm_network=g&utm_adpostion=&utm_creative=726015684141&utm_targetid=aud-1645446892440:dsa-2264919291789&utm_loc_interest_ms=&utm_loc_physical_ms=1015190&utm_content=&utm_campaign=230119_1-sea~dsa~tofu_2-b2c_3-us_4-prc_5-na_6-na_7-le_8-pdsh-go_9-nb-e_10-na_11-na-jan25&gad_source=1&gclid=Cj0KCQiAhbi8BhDIARIsAJLOlufNwz6i2E3y5xFWax-OrABRD7Oll5gXR7ewSeRyG9a9DPCxIAjk8jUaApEvEALw_wcB


https://www.jssm.org/jssm-23-537.xml%3EFulltext
https://www.nature.com/articles/s41598-024-74908-1#Sec2
https://www.nature.com/articles/s41597-024-03254-8?utm_source=chatgpt.com#Sec13
https://www.nature.com/articles/s41598-024-74908-1#Sec2
This article looks at what factors can lead to athletes burning out, and it turns out that these factors aren’t the same for everyone. The study compares athletes at different performance levels to see which things (like stress, training load, or support systems) might trigger burnout. In one of the main sections, the researchers explain the methods they used, like statistical models and various tests, to measure burnout and its intensity. The key takeaway is that athletes are not all the same—different groups have different warning signs and risk factors for burnout. Plus, the study found that some things, such as having strong social support or better coping strategies, can help lessen the risk. This suggests that when creating training or recovery programs, it might be a good idea to customize them for different athletes rather than using a one-size-fits-all approach.

https://www.nature.com/articles/s41597-024-03254-8?utm_source=chatgpt.com#Sec13
This article introduces a detailed dataset that can help researchers figure out how and when fatigue happens during shoulder movements (specifically during internal and external rotations). The paper explains how the data were collected, including things like muscle activity readings, motion capture information, and possibly self-reported fatigue levels. One of the main sections breaks down the dataset’s structure and how reliable it is. The goal is to give other researchers a solid foundation to build better models or algorithms that predict fatigue. This is really useful for applications in sports science, rehabilitation, or even workplace ergonomics. Overall, it shows that having a good dataset can lead to better tools for assessing fatigue, which could be a game changer in both sports and healthcare settings.

1. Fatigue Analysis Study, Summary:
In this study, the authors propose a new method that uses a fully-connected neural network with an increment learning scheme to predict how fatigue cracks grow. The method focuses on capturing the changes in crack growth over time under repeated loading conditions in metal structures. The cool part about this approach is that by using neural network learning, it can predict crack growth more accurately compared to traditional techniques.

Link: https://doi.org/10.1016/j.engfracmech.2020.107402
2. Injury Prediction Study, Summary:
This paper introduces a machine learning model that uses both external and internal training load data to evaluate the risk of non-contact injuries in professional soccer players. The study combines physical workload measures (like distance, speed, and accelerations) with physiological data (such as heart rate) to see how sudden spikes and overall workload trends might predict injuries. The results suggest that these combined metrics can forecast injury risk with pretty high accuracy.
Link: https://doi.org/10.52082/jssm.2024.537


https://archive.cdc.gov/www_cdc_gov/ncbddd/jointrom/index.html
Normal Joint Ranges according to the CDC for feature engineering and understanding

https://www.physio-pedia.com/Range_of_Motion_Normative_Values
Another one to compare it to



# Instructions

Create a GitHub page for the project

## GitHub:
#### 1. Create a GitHub account and Sign in
#### 2. Go to [https://github.com/capstone4ds/capstone4ds_template](https://github.com/capstone4ds/capstone4ds_template) and fork (create a copy to your GitHub)
![fork](fork.png)
#### 3. Change the name of the repo to *IDC6940_GroupName*
#### 4. Go to *Settings* -> *Pages* -> under *Branch* -> select *main*
#### 5. Wait for a few seconds and refresh the page. You see the link of the page. 

## RStudio:
#### 1. Go to RStudio
#### 2. Create a Version Control Project and Clone the repo.
#### 3. Commit and push to see changes on the website et Voilà!

More information:
- [GitHub](https://happygitwithr.com/index.html)
- [Video1 RStudio connection to GitHub](https://www.youtube.com/watch?v=MdmnE3AnkQE)
- [Video2 RStudio connection to GitHub](https://www.youtube.com/watch?v=jN6tvgt3GK8)
