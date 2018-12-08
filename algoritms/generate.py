# -*- coding: utf-8 -*-
"""
Created on Sat Dec  8 15:21:22 2018

@author: plotb
"""

import user_struct
import random as rnd
from datetime import datetime

print (datetime.now())

user_dic = {}

for key in range(100000):
    user_dic[key] = user_struct.user(key, rnd.uniform(0, 10000), rnd.uniform(0, 10000), datetime.utcnow())


print (datetime.now())
    


    
    