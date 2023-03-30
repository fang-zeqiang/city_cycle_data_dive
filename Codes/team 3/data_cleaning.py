# -*- coding: utf-8 -*-
"""
Created on Tue Mar 16 19:11:35 2021

@author: y.Xing
"""

import numpy as np
import pandas as pd
import requests
from patsy import dmatrices
import statsmodels.api as sm
import matplotlib.pyplot as plt

## Load the dataa
"""
url_central_london = "https://cycling.data.tfl.gov.uk/CycleCountsProgramme/Central%20London%20(area).xlsx"
url_inner_london = "https://cycling.data.tfl.gov.uk/CycleCountsProgramme/Inner%20London%20(area).xlsx"
url_outer_london = "https://cycling.data.tfl.gov.uk/CycleCountsProgramme/Outer%20London%20(area).xlsx"

def get_count_data(url:str, dest:str):
    resp = requests.get(url)
    with open('./'+dest + '.xlsx', 'wb') as output:
        output.write(resp.content)
        
get_count_data(url_central_london, "central_london")
get_count_data(url_inner_london, "inner_london")
get_count_data(url_outer_london, "outer_london")

def excel_to_csv(file_name:str):
    df = pd.read_excel("./"+file_name + ".xlsx", sheet_name = 1)
    df.to_csv(file_name + '.csv', sep='\t', index = False)
    return df

central_london = excel_to_csv("central_london")
inner_london = excel_to_csv("inner_london")
outer_london = excel_to_csv("outer_london")
"""
# Data cleaning and pre-processing
#central_london.csv
central_london = pd.read_csv('central_london.csv')
inner_london = pd.read_csv('inner_london.csv')
outerlondon = pd.read_csv('outer_london.csv')
count_sites_list = pd.read_csv('count_sites_list.csv',usecols=('UnqID','Borough'))
infrastructure = pd.read_csv('infrastructure.csv',usecols=('year','BOROUGH','infrastructure'))


df = pd.merge(central_london,count_sites_list,'left',left_on='Site ID',right_on='UnqID')
year = df['Survey wave (calendar quarter)'].str.split(' ',expand=True)
other_predictors = df.iloc[:,2:]
df = pd.concat([year,other_predictors],axis=1)
df.rename(columns={0: 'Year', 1: 'Quarter', 2: 'Month'}, inplace=True)
infrastructure['year']=infrastructure['year'].astype(str)
#choose year from 2017
df = df[df['Year'].astype(int)>2016]
#merge with the infrastructure data
#df=pd.merge(df, infrastructure,'left',left_on = ['Year','Borough'],right_on=['year','BOROUGH'])

pick_agg_cols = {'Number of normal cycles':['mean'],'Number of cycle hire bikes':['mean'], 'Total cycles':['mean']}
df_grouped = df.groupby(['Borough','Year','Quarter','Period','Weather']).agg(pick_agg_cols).reset_index()

df_grouped=pd.merge(df_grouped, infrastructure,'left',left_on = ['Year','Borough'],right_on=['year','BOROUGH'])
df_grouped=df_grouped.drop(columns=['year', 'BOROUGH'])
df_grouped.columns = ['Borough','Year','Quarter','Period','Weather','Normal_cycles','Hire_cycles','Total_cycles','Infras']
df_grouped['Year']=df_grouped['Year'].astype(int)
# Modelling

#Create the training and testing data sets.
mask = np.random.rand(len(df_grouped)) < 0.8
df_train = df_grouped[mask]
df_test = df_grouped[~mask]
print('Training data set length='+str(len(df_train)))
print('Testing data set length='+str(len(df_test)))


expr_train = """df_train['Total_cycles'] ~ df_train['Borough'] + df_train['Year'] + df_train['Quarter'] + df_train['Period'] + df_train['Weather']"""
expr_test = """df_test['Total_cycles'] ~ df_test['Borough'] + df_test['Year'] + df_test['Quarter'] + df_test['Period'] + df_test['Weather']"""

#Set up the X and y matrices
y_train, X_train = dmatrices(expr_train, df_train, return_type='dataframe')
y_test, X_test = dmatrices(expr_test, df_test, return_type='dataframe')

#Using the statsmodels GLM class, train the Poisson regression model on the training data set.
poisson_training_results = sm.GLM(y_train, X_train, family=sm.families.Poisson()).fit()

#Print the training summary.
print(poisson_training_results.summary())

#Make some predictions on the test data set.
poisson_predictions = poisson_training_results.get_prediction(X_test)
#.summary_frame() returns a pandas DataFrame
predictions_summary_frame = poisson_predictions.summary_frame()
print(predictions_summary_frame)

predicted_counts=predictions_summary_frame['mean']
actual_counts = y_test['Total_cycles']

#Mlot the predicted counts versus the actual counts for the test data.
fig = plt.figure()
fig.suptitle('Predicted versus actual total cycling counts')
predicted, = plt.plot(X_test.index, predicted_counts, 'go-', label='Predicted counts')
actual, = plt.plot(X_test.index, actual_counts, 'ro-', label='Actual counts')
plt.legend(handles=[predicted, actual])
plt.show()

#Show scatter plot of Actual versus Predicted counts
plt.clf()
fig = plt.figure()
fig.suptitle('Scatter plot of Actual versus Predicted counts')
plt.scatter(x=predicted_counts, y=actual_counts, marker='.')
plt.xlabel('Predicted counts')
plt.ylabel('Actual counts')
plt.show()