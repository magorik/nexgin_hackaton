# -*- coding: utf-8 -*-
"""
Created on Sun Dec  9 00:32:54 2018

@author: plotb
"""
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import sklearn.cluster as cluster
import time
import random

#data = np.zeros((1000,2))
#for i in range(1000):
#    data[i][1] = random.uniform(1,100)
#    data[i][0] = random.uniform(1,100)

def prepare_points(points):
    data = np.zeros((len(points),2))
    for i in range(len(points)):
        data[i][0] = float(points[i]._x)
        data[i][1] = float(points[i]._y)
    return data


def get_clusters(data, number_of_clusters):
    return cluster.KMeans(n_clusters=number_of_clusters).fit_predict(data)

    