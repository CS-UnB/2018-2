import os
import ycm_core

flags = [
    'Wall',
    'pthread',
    '-std=c99',
    '-x',
    'c',
]

def FlagsForFile(filename, **kwargs):
    return {
        'flags': flags
    }

