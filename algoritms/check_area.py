# -*- coding: utf-8 -*-
"""
Редактор Spyder

Это временный скриптовый файл.
"""
from matplotlib import path
import numpy as np
from datetime import datetime
import generate


p = path.Path([(0,0), (0, 1000), (1000, 1000), (1000, 0)])
dict_range = 100000
points = generate.generate_points(dict_range, 100)
print(points[1].to_json())
points = generate.generate_timestap(points, dict_range, 1)
print(points[1].to_json())
#names = ['user']
#formats = ['user']
#dtype = dict(names = names, formats = formats)
#np_pionts = np.array(list(points.items()),)
time = datetime.now()
for user in range(dict_range):
    p.contains_points([(points[user]._x, points[user]._y)])
print(datetime.now() - time)
#print(p.contains_points([(.5, .5)]))


