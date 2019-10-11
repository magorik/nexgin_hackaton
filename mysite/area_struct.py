# -*- coding: utf-8 -*-
"""
Created on Sun Dec  9 00:55:27 2018

@author: plotb
"""

from matplotlib import path
import json
import numpy as np

status_map = {(True, True):1, #остался
        (True, False):2,#вышел
        (False, True):3,#зашел
        (False, False):4 };# не заходил

class area_struct:
    def __init__(self, message, id):
        self._id = id
        self._status = 1
        self._history = [False, False]
        pathString = message.split(',')
        self._path = path.Path([(pathString[0],pathString[1]),(pathString[2],pathString[3]),(pathString[4],pathString[5]),(pathString[6],pathString[7])])        

    def to_json(self):
        return json.dumps(self)
    
    def changing_includes(self, value):
        self._history[0] = self._history[1]
        self._history[1] = value
        self._status = status_map[(bool(self._history[0]), bool(self._history[1]))]
        