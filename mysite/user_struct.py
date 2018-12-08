# -*- coding: utf-8 -*-
"""
Created on Sat Dec  8 15:24:44 2018

@author: plotb
"""
import json
#from collections import OrderedDict

class user:
    def __init__(self, user_id, x, y, timestap):
        self._user_id = user_id
        self._x = x
        self._y = y
        self._timestap = timestap
        
    def to_json(self):
        return json.dumps(self)