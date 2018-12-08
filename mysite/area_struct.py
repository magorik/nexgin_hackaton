# -*- coding: utf-8 -*-
"""
Created on Sun Dec  9 00:55:27 2018

@author: plotb
"""

import json

status_map = {(True, True):1, #остался
        (True, False):2,#вышел
        (False, True):3,#зашел
        (False, False):4# не заходил
        };


class area_struct:
    def __init__(self, path):
        self._id = ''
        self._status = ''
        self._history = [False, False]
        self._path = path
        
    def to_json(self):
        return json.dumps(self)
    
    def changing_includes(self, value):
        self._history[0] = self._history[1]
        self._history[1] = value
        self._status = status_map[(self._history[0], self._history[1])]
        