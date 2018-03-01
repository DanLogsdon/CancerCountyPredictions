# -*- coding: utf-8 -*-
"""
Created on Mon Feb 26 11:33:08 2018

@author: 593419
"""
#%% Imports
import pandas as pd
import numpy as np
from sklearn.cross_validation import train_test_split
from sklearn.ensemble import RandomForestClassifier

#%%
file=r'C:/Users/593419/Documents/Rscripts/test_data.csv'
testdata=pd.read_csv(file)
train=testdata.sample(frac=0.75, random_state=50)
test=testdata.drop(train.index) 
rf1=RandomForestClassifier(n_jobs=1, n_estimators=60, oob_score=True, max_features=0.3, max_depth=10)
rf2=rf1.fit(train[train.columns[2:]], train["Cancer"])

importances = rf2.feature_importances_
std = np.std([tree.feature_importances_ for tree in rf2.estimators_],
             axis=0)
indices = np.argsort(importances)[::-1]

#for i in range (0,test.shape[1]-2):
 #   print("feature:  " + test.columns[indices[i] +2] + " (%f)" % (importances[indices[i]]))

#%% Importing the R map FIPS Codes

file=r'C:/Users/593419/Documents/PythonScripts/County Map/counties.csv'
mapdata=pd.read_csv(file)
mapdata=mapdata.drop(['County', 'Cancer_Incidence', 'number'], axis=1)
mapdata=mapdata.dropna()

#%% Reset 
alltest=pd.DataFrame()
alltest['FIPS']=testdata['FIPS']
alltest['Cancer']=rf2.predict(testdata[testdata.columns[2:]])

#%%
keys=alltest.set_index('FIPS').to_dict()['Cancer']

#%% 
mapdata['Cancer']=mapdata['FIPS'].map(keys)
mapdata.to_csv('rdata.csv', index_label='number')

#%% Important Variables
file=r'C:/Users/593419/Documents/Rscripts/fromr.csv'
rvariables=pd.read_csv(file)
rvariables=rvariables.drop(rvariables.columns[0], axis=1)

#%% 
i=0
rtest=pd.DataFrame()
rtest=testdata
#%%
for variable in rvariables["x"]:
    if variable == 1:
       i=i+1 
    else:
       rtest[rtest.columns[indices[i] +2]]=rtest[rtest.columns[indices[i] +2]]*variable
       i=i+1
#%%       
alltest['FIPS']=rtest['FIPS']
alltest['Cancer']=rf2.predict(rtest[rtest.columns[2:]])
keys=alltest.set_index('FIPS').to_dict()['Cancer']
#%%
mapdata['Cancer']=mapdata['FIPS'].map(keys)
mapdata.to_csv('fromp.csv', index_label='number')          


  
    




