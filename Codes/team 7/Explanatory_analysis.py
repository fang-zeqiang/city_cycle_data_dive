import pandas as pd
import numpy as np
from datetime import datetime
from matplotlib.dates import date2num
import matplotlib.pyplot as plt
import sklearn.linear_model as linear_model
import sklearn.metrics as metrics
import statsmodels.api as sm
from scipy import stats
from sklearn.model_selection import train_test_split
pd.set_option('display.max_columns', None)

holiday_data = pd.read_csv('data/bankholiday(2017-2021).csv', parse_dates=True)
hdays = pd.concat([holiday_data['2020'], holiday_data['2021']])
hdays = [datetime.strptime(x, "%Y-%m-%d") for x in hdays]

def filter_data(df):
    df['day_of_week'] = df['date'].dt.dayofweek
    df['weekday'] = ~df['day_of_week'].isin([5, 6])
    df['weekend'] = df['day_of_week'].isin([5, 6])
    df['holiday'] = df['date'].isin(hdays)
    df = df.replace({True: 1, False: 0})
    return df

PLOTS_DIR = 'plots/'

df = pd.read_csv('data/apple_mobility.csv',parse_dates=True)
df['date'] = [datetime.strptime(x, "%d/%m/%Y") for x in df['date']]
hw_df = pd.read_csv('data/activity_homeworking.csv')
hw_df['date'] = [datetime.strptime(x, "%Y-%m-%d") for x in hw_df['date']]
case_df = pd.read_csv('data/data_2021-Mar-16.csv', parse_dates=False)
case_df['date'] = [datetime.strptime(x, "%d/%m/%Y") for x in case_df['date']]

#filter working from home data
hw_df = filter_data(hw_df)
hw1_df = hw_df.loc[(hw_df['activity'] == 'Residential') & (
        hw_df['weekday'] == 1) & (hw_df['holiday'] == 0)].drop(columns=['location','source'])
hw0_df = hw_df.loc[(hw_df['activity'] == 'Workplaces') & (
        hw_df['weekday'] == 1) & (hw_df['holiday'] == 0)].drop(columns=['location','source'])

#filter covid-19 cases data
case_df = case_df.loc[case_df['date'].isin(df['date'])].drop(columns=['areaType','areaName','areaCode'])
df_new = pd.merge(df, case_df, on='date')

#visualize school_closed restriction
fig, ax = plt.subplots(figsize=(12, 6))
ax.plot(df['date'], df['driving'], label='driving')
ax.plot(df['date'], df['transit'], label='transit')
ax.plot(df['date'], df['walking'], label='walking')
ax.set_xlabel('Time')
ax.axvspan(date2num(datetime(2020,3,23)), date2num(datetime(2020,5,31)), color="grey", alpha=0.15)
ax.axvspan(date2num(datetime(2021,1,5)), date2num(datetime(2021,3,7)), color="grey", alpha=0.15)
ax.set_title('School Closed Restriction', size=18)
ax.grid(True)
ax.legend(loc='best')
#plt.savefig(PLOTS_DIR + 'school_closed_restriction' + '.png')
plt.show()
plt.close()

#visualize pub_closed restriction
#df = get_day_of_week(df).loc[df['weekend'] == 1]
fig, ax = plt.subplots(figsize=(12, 6))
ax.plot(df['date'], df['driving'], label='driving')
ax.plot(df['date'], df['transit'], label='transit')
ax.plot(df['date'], df['walking'], label='walking')
ax.set_xlabel('Time')
ax.axvspan(date2num(datetime(2020,3,21)), date2num(datetime(2020,7,3)), color="grey", alpha=0.15)
ax.axvspan(date2num(datetime(2020,11,5)), date2num(datetime(2020,12,1)), color="grey", alpha=0.15)
ax.axvspan(date2num(datetime(2020,12,16)), date2num(datetime(2021,3,14)), color="grey", alpha=0.15)
ax.set_title('Pubs Closed Restriction', size=18)
ax.grid(True)
ax.legend(loc='best')
#plt.savefig(PLOTS_DIR + 'pub_restriction' + '.png')
plt.show()
plt.close()

#visualize lockdown restriction
fig, ax = plt.subplots(figsize=(12, 6))
ax.plot(df['date'], df['driving'], label='driving')
ax.plot(df['date'], df['transit'], label='transit')
ax.plot(df['date'], df['walking'], label='walking')
ax.set_xlabel('Time')
ax.axvspan(date2num(datetime(2020,3,24)), date2num(datetime(2020,5,10)), color="grey", alpha=0.15)
ax.axvspan(date2num(datetime(2020,11,5)), date2num(datetime(2020,12,1)), color="grey", alpha=0.15)
ax.axvspan(date2num(datetime(2020,12,20)), date2num(datetime(2021,3,14)), color="grey", alpha=0.15)
ax.set_title('Lockdown Restriction', size=18)
ax.grid(True)
ax.legend(loc='best')
#plt.savefig(PLOTS_DIR + 'lockdown' + '.png')
plt.show()
plt.close()

#visualize working from home data
fig, ax = plt.subplots(figsize=(12, 6))
ax.plot(hw0_df['date'], hw0_df['value'], label='Workplaces')
ax.plot(hw1_df['date'], hw1_df['value'], label='Residential')
ax.set_xlabel('Time')
ax.axvspan(date2num(datetime(2020,3,24)), date2num(datetime(2020,5,10)), color="grey", alpha=0.15)
ax.axvspan(date2num(datetime(2020,11,5)), date2num(datetime(2020,12,1)), color="grey", alpha=0.15)
ax.axvspan(date2num(datetime(2020,12,20)), date2num(datetime(2021,3,14)), color="grey", alpha=0.15)
ax.set_title('Lockdown Restriction-Working from home', size=18)
ax.grid(True)
ax.legend(loc='upper right')
#plt.savefig(PLOTS_DIR + 'work_from_home' + '.png')
plt.show()
plt.close()

#visualize death number
fig, ax1 = plt.subplots(figsize=(12, 6))
ax1.plot(df_new['date'], df_new['driving'], label='driving')
ax1.plot(df_new['date'], df_new['transit'], label='transit')
ax1.plot(df_new['date'], df_new['walking'], label='walking')
ax1.set_xlabel('Time')
ax1.axvspan(date2num(datetime(2020,3,24)), date2num(datetime(2020,5,10)), color="grey", alpha=0.15)
ax1.axvspan(date2num(datetime(2020,11,5)), date2num(datetime(2020,12,1)), color="grey", alpha=0.15)
ax1.axvspan(date2num(datetime(2020,12,20)), date2num(datetime(2021,3,14)), color="grey", alpha=0.15)
ax1.set_title('Lockdown Restriction with daily death number', size=18)
ax1.grid(True)
ax1.legend(loc='best')

ax2 = ax1.twinx()
ax2.plot(df_new['date'], df_new['newDeaths28DaysByDeathDate'], label='deaths', color='black')
ax2.legend(loc='best')
fig.tight_layout()
#plt.savefig(PLOTS_DIR + 'covid-19 deaths' + '.png')
plt.show()
plt.close()

#visualize case number
fig, ax1 = plt.subplots(figsize=(12, 6))
ax1.plot(df_new['date'], df_new['driving'], label='driving')
ax1.plot(df_new['date'], df_new['transit'], label='transit')
ax1.plot(df_new['date'], df_new['walking'], label='walking')
ax1.set_xlabel('Time')
ax1.axvspan(date2num(datetime(2020,3,24)), date2num(datetime(2020,5,10)), color="grey", alpha=0.15)
ax1.axvspan(date2num(datetime(2020,11,5)), date2num(datetime(2020,12,1)), color="grey", alpha=0.15)
ax1.axvspan(date2num(datetime(2020,12,20)), date2num(datetime(2021,3,14)), color="grey", alpha=0.15)
ax1.set_title('Lockdown Restriction with daily cases', size=18)
ax1.grid(True)
ax1.legend(loc='best')

ax2 = ax1.twinx()
ax2.plot(df_new['date'], df_new['newCasesBySpecimenDate'], label='cases', color='red')
ax2.legend(loc='best')
fig.tight_layout()
#plt.savefig(PLOTS_DIR + 'covid-19 cases' + '.png')
plt.show()
plt.close()

#analyse mobility data with restrictions
r_df = pd.read_csv('data/restrictions_daily.csv',parse_dates=True)
r_df['date'] = [datetime.strptime(x, "%d/%m/%Y") for x in r_df['date']]
ld_df = r_df[['date','stay_at_home','length']]
df_new = df_new.merge(ld_df, on='date').fillna(0)
df_new = filter_data(df_new)
df_new['case_ratio'] = df_new['newCasesBySpecimenDate'] / np.mean(df_new['newCasesBySpecimenDate']) * 100
df_new['death_ratio'] = df_new['newDeaths28DaysByDeathDate'] / np.mean(df_new['newDeaths28DaysByDeathDate']) * 100
df_new['case_ratio'] = df_new.apply(lambda x: np.log(x['case_ratio']), axis=1)
df_new['death_ratio'] = df_new.apply(lambda x: np.log(x['death_ratio'] + 1), axis=1)
print(df_new.iloc[-10:,])


#regression analysis
X = df_new[['stay_at_home','length','weekday','weekend','holiday','case_ratio','death_ratio']].to_numpy()
y_d = df_new['driving'].to_numpy()
y_t = df_new['transit'].to_numpy()
y_w = df_new['walking'].to_numpy()
est = sm.OLS(y_d, X)
est_d = est.fit()
print('driving mobility analysis')
print(est_d.summary())
print('')
est = sm.OLS(y_t, X)
est_t = est.fit()
print('transit mobility analysis')
print(est_t.summary())
print('')
est = sm.OLS(y_w, X)
est_w = est.fit()
print('walking mobility analysis')
print(est_w.summary())
