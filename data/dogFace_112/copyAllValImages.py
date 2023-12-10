import os
import random
import shutil

valDir = 'val'
outputDir = 'val_all_imgs'

for root, dirs, files in os.walk(valDir):
    for filename in files:
        shutil.copy2(os.path.join(root, filename), outputDir)

