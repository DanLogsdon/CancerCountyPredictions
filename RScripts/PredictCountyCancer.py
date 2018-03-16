# -*- coding: utf-8 -*-
"""
Created on Thu Mar 15 14:28:58 2018

@author: 593419
"""

#%% Package Imports
import pandas as pd
import numpy as np
from sklearn.cross_validation import train_test_split
from sklearn.ensemble import RandomForestClassifier
import pickle

#%% Reading the Top 5 Effector Values From R
file=r'C:/Users/593419/Documents/Rscripts/fromr.csv'
rvariables=pd.read_csv(file)
rvariables=rvariables.drop(rvariables.columns[0], axis=1)

file=r'C:/Users/593419/Documents/Rscripts/alldata.csv'
alldata=pd.read_csv(file)
alldata=alldata.dropna()

#%% Loading the trained RF model
rf2=pickle.load(open('trained_rf_model.sav','rb'))
importances = rf2.feature_importances_
std = np.std([tree.feature_importances_ for tree in rf2.estimators_],
             axis=0)
indices = np.argsort(importances)[::-1]

#%% Pulling the FIPS code
i=0
rtest=pd.DataFrame()
FIPS=rvariables["x"].iloc[0]
rtest=alldata.loc[alldata['FIPS'] == FIPS]
#%%
for variable in rvariables["x"]:
    if variable==FIPS:
       i=0 
    else:
        rtest[rtest.columns[indices[i] +1]]=variable
        i=i+1
cancerval=pd.DataFrame()        
cancerval=rf2.predict(rtest[rtest.columns[1:]])
rvariables['New_Value']=cancerval  