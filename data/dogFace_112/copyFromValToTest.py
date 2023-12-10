import os
import random
import shutil
import sys

valDir = 'val'
outputDir = 'test'
for _ in range(0,213):
    root, dirs, _ = next(os.walk(valDir))
    random.shuffle(dirs)
    shutil.move(os.path.join(root, dirs[0]), outputDir)

