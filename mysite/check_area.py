# -*- coding: utf-8 -*-
"""
Редактор Spyder

Это временный скриптовый файл.
"""
from matplotlib import path
import numpy as np
from datetime import datetime
import generate
import area_struct



#p = path.Path([(0,0), (0, 1000), (1000, 1000), (1000, 0)])
#dict_range = 100000
#points = generate.generate_points(dict_range, 100)
#print(points[1].to_json())
#points = generate.generate_timestap(points, dict_range, 1)
#print(points[1].to_json())
#names = ['user']
#formats = ['user']
#dtype = dict(names = names, formats = formats)
#np_pionts = np.array(list(points.items()),)
#time = datetime.now()
#for user in range(dict_range):
#    p.contains_points([(points[user]._x, points[user]._y)])
#print(datetime.now() - time)
#print(p.contains_points([(.5, .5)]))

def check_square_area(area, points):
    area_id = area._id

    for user_id in range (1, len(points)):
        user = points[user_id]
        
        status = check_area(area._path, float(user._x), float(user._y))
        
        try:
            user._area[area_id]
            # Добавляем новую обасть
        except:
            user._area[area_id] = area

        user._area[area_id].changing_includes(status)
        
        #points[user]._true_true = str(bool(bool(points[user-1]._area_status) & bool(points[user]._area_status))) #остался в зоне
        #points[user]._true_false = str(bool(bool(points[user-1]._area_status) & ~bool(points[user]._area_status)))#вышел из зоны
        #points[user]._false_true = str(bool(~bool(points[user-1]._area_status) & bool(points[user]._area_status)))#зашел в зону
        #points[user]._false_false = str(bool(~bool(points[user-1]._area_status) & ~bool(points[user]._area_status)))#вне зоны был и остался
    return points
        
def check_area(area, x, y):
    return area.contains_points([(x, y)])






