# -*- coding: utf-8 -*-
"""
Редактор Spyder

Это временный скриптовый файл.
"""
from matplotlib import path




p = path.Path([(0,0), (0, 1), (1, 1), (1, 0)])
print(p.contains_points([(.5, .5)]))