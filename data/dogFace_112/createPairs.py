import os
import random
import sys


numPositiveSamples = int(sys.argv[3])
numNegativeSamples = int(sys.argv[4])

outputLineSet = set()

valDir = sys.argv[1]
outputDir = sys.argv[2]

# create positive samples
while len(outputLineSet) < numPositiveSamples:
    root, dirs, _ = next(os.walk(valDir))
    random.shuffle(dirs)
    nextDir = dirs[0]
    _, _, files = next(os.walk(os.path.join(root, nextDir)))

    random.shuffle(files)

    file1 = files[0]
    file2 = files[1]

    if file1 < file2:
        outputTuple = (file1, file2, '1')
        outputLine = ' '.join(outputTuple) + '\n'
        outputLineSet.add(outputLine)
    else:
        outputTuple = (file2, file1, '1')
        outputLine = ' '.join(outputTuple) + '\n'
        outputLineSet.add(outputLine)


# create negative samples
while len(outputLineSet) < (numPositiveSamples + numNegativeSamples):
    _, dirs, _ = next(os.walk(valDir))
    random.shuffle(dirs)

    dir1 = dirs[0]
    dir2 = dirs[1]

    _, _, files = next(os.walk(os.path.join(root, dir1)))

    random.shuffle(files)

    file1 = files[0]

    _, _, files = next(os.walk(os.path.join(root, dir2)))

    random.shuffle(files)

    file2 = files[0]

    if file1 < file2:
        outputTuple = (file1, file2, '0')
        outputLine = ' '.join(outputTuple) + '\n'
        outputLineSet.add(outputLine)
    else:
        outputTuple = (file2, file1, '0')
        outputLine = ' '.join(outputTuple) + '\n'
        outputLineSet.add(outputLine)

with open(outputDir, 'w') as f:
    for outputLine in outputLineSet:
            f.write(outputLine)
