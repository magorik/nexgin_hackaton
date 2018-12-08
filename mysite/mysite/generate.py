# -*- coding: utf-8 -*-
"""
Created on Sat Dec  8 15:21:22 2018

@author: plotb
"""

import user_struct
import random as rnd
from datetime import datetime
import numpy as np
import time


def generate_points(count, maximum_range_float):
    time_a = datetime.now()
    user_dic = {}
    for line in range(count):
        #result = user_struct.user(line, rnd.uniform(0, 10000), rnd.uniform(0, 10000), datetime.utcnow())
        #print(result)
        #result_array = np.append(result_array, [result], axis=count)
        system_time = time.time()
        user_dic[line] = user_struct.user(line, rnd.uniform(0, maximum_range_float), rnd.uniform(0, maximum_range_float), system_time)
        print(user_dic[line].to_json())
    print (datetime.now() - time_a)
    return user_dic

def generate_timestap(user_dict, count, time_delay):
    time_a = time.time()
    for line in range(count):
        user_dict[line]._x = user_dict[line]._x + rand_float(-1.0, 1.0)
        user_dict[line]._y = user_dict[line]._y + rand_float(-1.0, 1.0)
        user_dict[line]._timestap = time_a
    return(user_dict)    
    
def rand_float(minimum, maximum):
    return minimum + (maximum - minimum) * rnd.random()





    


    
    