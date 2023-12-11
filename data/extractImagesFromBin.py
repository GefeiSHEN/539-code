import mxnet as mx
from tqdm import tqdm
from PIL import Image
import bcolz
import pickle
import cv2
import numpy as np
bins, issame_list = pickle.load(open('cplfw.bin', 'rb'), encoding='bytes')

bin0 = bins[0]
img0Filename = 'img' + str(0) + '.jpg'
img0RelPath = 'imgs/' + img0Filename

bin1 = bins[1]
img1Filename = 'img' + str(1) + '.jpg'
img1RelPath = 'imgs/' + img1Filename


img0 = mx.image.imdecode(bin0).asnumpy()
img0 = Image.fromarray(img0.astype(np.uint8))

img1 = mx.image.imdecode(bin1).asnumpy()
img1 = Image.fromarray(img1.astype(np.uint8))

with open('pairs_cplfw.txt', 'w') as f:

    for i in range(0, len(bins)):
        if i % 2 == 0:
            bin0 = bins[i]
            img0Filename = 'img' + str(i) + '.jpg'
            img0RelPath = 'imgs/' + img0Filename

            img0 = mx.image.imdecode(bin0).asnumpy()
            img0 = Image.fromarray(img0.astype(np.uint8))
        else:
            bin1 = bins[i]
            img1Filename = 'img' + str(i) + '.jpg'
            img1RelPath = 'imgs/' + img1Filename

            img1 = mx.image.imdecode(bin1).asnumpy()
            img1 = Image.fromarray(img1.astype(np.uint8))

            img0.save(img0RelPath, quality=95)
            img1.save(img1RelPath, quality=95)

            pairsFileTuple = (img0Filename, img1Filename, str(issame_list[i // 2]))

            pairsFileOutput = ' '.join(pairsFileTuple) + '\n'
            f.write(pairsFileOutput)

