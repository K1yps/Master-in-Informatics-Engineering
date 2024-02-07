# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

# In[0]:
import seaborn as sns
import matplotlib.pyplot as plt
%matplotlib inline

# In[1]:

from sklearn.datasets import make_blobs


data = make_blobs(n_samples=200,n_features=2,centers=4,cluster_std=1.8,random_state=2021)

X = data[0]
y = data[1]

print(f'X:{X[0:5,:]}\nY:{y[0:5]}')


# In[2]:

from sklearn.cluster import KMeans

kmeans = KMeans(n_clusters=4, random_state=2021)
kmeans.fit(X)

kmeans.cluster_centers_


kmeans.labels_


f, (ax1,ax2) = plt.subplots(1,2,sharey=True, figsize=(10,6))
ax1.set_title('K Means?')
ax1.scatter(X[:,0],X[:,1],c=kmeans.labels_, cmap='rainbow')
ax2.set_title("Original")
ax2.scatter(X[:,0],X[:,1], c=y, cmap='rainbow')



# In[3]:

from sklearn.metrics import classification_report,confusion_matrix
import numpy as np


y_pred = kmeans.predict(X)


y_pred = np.where(y_pred==3,10,y_pred)
y_pred = np.where(y_pred==1,3,y_pred)
y_pred = np.where(y_pred==10,1,y_pred)

print(confusion_matrix(y, y_pred))

print(classification_report(y, y_pred))



# In[4]:
    
from sklearn_extra.cluster import KMedoids


kmedoids= KMedoids(n_clusters=4, random_state=2021)
kmedoids.fit(X)

kmedoids.cluster_centers_

kmedoids.labels_


f, (ax1,ax2) = plt.subplots(1,2,sharey=True, figsize=(8,5))
ax1.set_title('K Medoids')
ax1.scatter(X[:,0],X[:,1],c=kmedoids.labels_, cmap='rainbow')
ax2.set_title("Original")
ax2.scatter(X[:,0],X[:,1], c=y, cmap='rainbow')


    
    
    
    
    
    
    



