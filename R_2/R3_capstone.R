

  
diet = select_cols(df_diet, demo_var, name="diet1")


demo = select_cols(df_demo, demo_keep,
                   rename={"RIDAGEYR":"age","RIAGENDR":"sex"}, name="df_demo")

diet = select_cols(df_diet, diet_keep, name="df_diet")

exam = select_cols(df_exam, exam_keep,
                   rename={"BMXBMI":"BMI","BPXCHR":"HR",
                           "BPXSY1":"SBP1","BPXDI1":"DBP1"}, name="df_exam")
                           ---------------------------------------------
                           demo_1 = df_demo = pd.read_csv("data/demographic.csv") 
diet_1 = df_diet = pd.read_csv("data/diet.csv") 
exam_1 = df_exam = pd.read_csv("data/examination.csv")
labs_1 = df_labs = pd.read_csv("data/labs.csv")
quest_1 = df_quest = pd.read_csv("data/questionnaire.csv")
  

print(demo_1.columns)
print(demo_1.dtypes)
print(demo_1.describe())
print(demo_1.info())


# Check for missing values in each column
print(df.isnull().sum())

# Drop rows with any missing values
df_cleaned = df.dropna()

# Fill missing values in a specific column with a mean
df['column_name'].fillna(df['column_name'].mean(), inplace=True)


import matplotlib.pyplot as plt
import seaborn as sns

# Histogram of a numeric column
plt.hist(df['numeric_column'])
plt.title('Histogram of Numeric Column')
plt.xlabel('Value')
plt.ylabel('Frequency')
plt.show()

# Box plot of a numeric column
sns.boxplot(y=df['numeric_column'])
plt.title('Box Plot of Numeric Column')
plt.show()

# Scatter plot between two numeric columns
sns.scatterplot(x='column_x', y='column_y', data=df)
plt.title('Scatter Plot of Column X vs Column Y')
plt.show()

# Bar plot for a categorical column
sns.countplot(x='categorical_column', data=df)
plt.title('Count of Categorical Column Categories')
plt.show()

# Correlation matrix heatmap
correlation_matrix = df.corr(numeric_only=True)
sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm')
plt.title('Correlation Matrix')
plt.show()

demo_10 = demo_1.rename(columns= {'RIDAGEYR':'age', 'RIAGENDR':'sex','RIDRETH1':'ethinicity'})






demo_var = ["RIDAGEYR","RIAGENDR","RIDRETH1"]
diet_var = ["DSD010 "]         
exam_var = ["BMDBMIC "] 
quest_var = ["CDQ009F ","MCQ160C","SMD030 "]
lab_var = ["LBDTCSI"]
                   

demo_2 = pd.read_csv('df_demo.csv, usecols=['SEQN','RIDAGEYR','RIAGENDR','RIDRETH1'])















import pandas as pd
import numpy as np

# Recode special codes to NaN for these items
mcq = ["MCQ160E","MCQ160C","MCQ160D","MCQ160F"]
df[mcq] = df[mcq].apply(pd.to_numeric, errors="coerce").replace({7: np.nan, 9: np.nan})

# Adult filter (RIDAGEYR is NHANES age in years at screening)
adults = df[df["RIDAGEYR"] >= 20].copy()

# CVD outcome: 1 if any “Yes”, 0 if all “No”, else NA
any_yes = adults[mcq].eq(1).any(axis=1)
all_no  = adults[mcq].eq(2).all(axis=1)
adults["CVD"] = pd.Series(pd.NA, index=adults.index)
adults.loc[any_yes, "CVD"] = 1
adults.loc[all_no,  "CVD"] = 0

# Check missing % for MCQ160F and for CVD outcome
miss_f = adults["MCQ160F"].isna().mean()*100
miss_cvd = adults["CVD"].isna().mean()*100
print(f"MCQ160F missing (adults): {miss_f:.1f}%")
print(f"CVD outcome missing (adults): {miss_cvd:.1f}%")






