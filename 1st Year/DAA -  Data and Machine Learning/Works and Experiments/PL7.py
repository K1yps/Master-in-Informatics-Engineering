# -*- coding: utf-8 -*-
"""
Created on Thu Nov 25 09:09:59 2021

"""

# In[Imports]

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
%matplotlib inline

# In[Data Input]

USAh = pd.read_csv('USA_Housing.csv')
USAh.drop('Address',axis=1,inplace=True)

USAh.head()


# In[Data Visualization]

sns.distplot(USAh['Price'])
sns.heatmap(USAh.corr())

# In[Tensor Imports]

import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Dropout, BatchNormalization
from tensorflow.keras.wrappers.scikit_learn import KerasRegressor
from tensorflow.model_selection import *
from sklearn.preprocessing import MinMaxScaler

RANDOM_SEED = 2021

print("TensorFlow version", tf.__version__)

# In[Work]


X = USAh.drop('Price',axis=1)
y = USAh[['Price']]

scaler_X = MinMaxScaler(feature_range=(0,1)).fit(X)
scaler_y = MinMaxScaler(feature_range=(0,1)).fit(y)

X_scaled = pd.DataFrame(scaler_X.transform(X[X.columns]), columns = X.columns)
y_scaled = pd.DataFrame(scaler_y.transform(y[y.columns]),columns=y.columns)


X.head()
X_scaled.head()

