#!/usr/bin/python3
##        (C) COPYRIGHT Ingenic Limited.
##             ALL RIGHTS RESERVED
##
## File       : __init__.py
## Authors    : zhluo@aries
## Create Time: 2017-08-15:15:57:55
## Description:
## 
##
import os.path as osp
import sys

def add_path(path):
    if path not in sys.path:
        sys.path.insert(0, path)

this_dir = osp.dirname(__file__)
lib_path = osp.join(this_dir, 'activation_util')
add_path(lib_path)
