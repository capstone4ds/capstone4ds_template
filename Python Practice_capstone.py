## 
import numpy as np
import random
import math
import statsmodels.api as stat
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import statsmodels.api as stat
import statsmodels.formula.api as smf
 from sklearn.feature_selection import SelectKBest, chi2, f_classif
    import pandas as pd
    from sklearn.datasets import load_iris

## 
# View the first 5 rows
print(df.head())

# View the last 5 rows
print(df.tail())

# Get the number of rows and columns
print(df.shape)

# Get the names of the columns
print(df.columns)

# Get data types of each column
print(df.dtypes)

# Get a summary of the DataFrame including index, datatype, and memory information
print(df.info())

# Get summary statistics for numeric columns
print(df.describe())

df_demo = pd.read_csv("data/demographic.csv", names = ["RIDAGEYR","RIAGENDR","RIDRETH1"])
df_diet = pd.read_csv("data/diet.csv", names = ["DSD010 "]  ) 
df_exam = pd.read_csv("data/examination.csv",names = ['BMDBMIC'])
df_labs = pd.read_csv("data/labs.csv", names = ["LBDTCSI"])
df_quest = pd.read_csv("data/questionnaire.csv", names =["CDQ009F ","MCQ160C","SMD030 "])


demo_1 = df_demo.rename(columns= {'RIDAGEYR':'age', 'RIAGENDR':'sex','RIDRETH1':'ethnicity'})
diet_1 = df_diet.rename(columns= {'DSD010':'diet suppl'})
exam_1 = df_exam.rename(columns= {'BMDBMIC': 'BMI'})
labs_1 = df_labs.rename(columns= {'LBDTCSI': 'Total Cholesterol'})
quest_1 = df_quest.rename(columns= {'CDQ009F': "Chest Pain",  'MCQ160C': "CVD", 'SMD030':"Smoking"})


print(demo_1.head())
print(demo_1.columns)
print(demo_1.dtypes)
print(demo_1.describe())
print(demo_1.info())


# Check for missing values in each column
print(quest_1.isnull().sum())


demo_1.sex.describe

demo_1.groupby('ethnicity').ethnicity.count()


n = len(quest_1)
miss = quest_1["Chest Pain",  "CVD", "Smoking"].isna().sum()
pct  = (miss / n * 100).round(1)
print(pd.DataFrame({"missing": miss, "missing_%": pct}))

# Drop rows with any missing values
df_cleaned = df.dropna()

# Fill missing values in a specific column with a mean
df['column_name'].fillna(df['column_name'].mean(), inplace=True)


import matplotlib.pyplot as plt
import seaborn as sns

# Histogram of a numeric column
plt.hist(demo_1['age'])
plt.title('Histogram of age')
plt.xlabel('age')
plt.show()

plt.hist(demo_1['age'], bins=20, edgecolor='black')
plt.title('Histogram of Age')
plt.xlabel('Age')
plt.ylabel('Frequency')
plt.show()


print(demo_1['age'].head())
print(demo_1['age'].describe())


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








demo_var = ["RIDAGEYR","RIAGENDR","RIDRETH1"]
diet_var = ["DSD010 "]         
exam_var = ["BMDBMIC "] 
quest_var = ["CDQ009F ","MCQ160C","SMD030 "]
lab_var = ["LBDTCSI"]
                   



merged_data = pd.merge(data1, data2, on='customer_id', how='inner')

print(merged_data)



import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

demo1=pd.read_csv("data/demographic.csv")
exam1=pd.read_csv("data/examination.csv")
quest1=pd.read_csv("data/questionnaire.csv")
demo1.head()
exam1.head()
quest1.head()

demo1.shape
exam1.shape
quest1.shape

demo1.dtypes
demo1.info()
demo1.columns
demo1.RIAGENDR.unique()

include =['object', 'float', 'int'] 
demo1.describe(include=include)

demo1.isnull().sum()
demo1.RIAGENDR.value_counts()

quest1.DIQ240.value_counts()
quest1.DIQ240.value_counts(normalize=True).mul(100).round(1).astype(str) + '%'


quest1["DIQ240"].hist(figsize=(10, 5))
plt.show()

demo1["RIAGENDR"].hist(figsize=(10, 5))
plt.show()

demo1["RIDAGEYR"].hist(figsize=(10, 5))
plt.show()












