import mxnet as mx
from mxnet import ndarray as nd
import argparse
import pickle
import sys
import os

def get_paths(lfw_dir, pairs):
    nrof_skipped_pairs = 0
    path_list = []
    issame_list = []

    for pair in pairs:
        # Ensure the pair has at least two elements
        if len(pair) < 2:
            print('Skipped pair:', pair)
            nrof_skipped_pairs += 1
            continue

        path0 = os.path.join(lfw_dir, pair[0])
        path1 = os.path.join(lfw_dir, pair[1])

        # Assume label is 1 as default
        issame = pair[2] == '1'

        if os.path.exists(path0) and os.path.exists(path1):
            path_list += (path0, path1)
            issame_list.append(issame)
        else:
            print('not exists', path0, path1)
            nrof_skipped_pairs += 1

    if nrof_skipped_pairs > 0:
        print('Skipped %d image pairs' % nrof_skipped_pairs)

    return path_list, issame_list

def read_pairs(pairs_filename):
    pairs = []
    with open(pairs_filename, 'r') as f:
        for line in f.readlines():
            pair = line.strip().split()
            pairs.append(pair)
    return pairs

def main():
    parser = argparse.ArgumentParser(description='Package LFW images')
    parser.add_argument('--data-dir', default='', help='')
    parser.add_argument('--image-size', type=str, default='112,96', help='')
    parser.add_argument('--output', default='', help='path to save.')
    args = parser.parse_args()

    lfw_dir = args.data_dir
    image_size = [int(x) for x in args.image_size.split(',')]
    
    pairs_file = 'data/dogFace_112/dogFaces_pairs.txt'
    lfw_pairs = read_pairs(pairs_file)

    lfw_paths, issame_list = get_paths(lfw_dir, lfw_pairs)

    # Load and preprocess images
    lfw_bins = []
    i = 0
    for path in lfw_paths:
        with open(path, 'rb') as fin:
            _bin = fin.read()
            lfw_bins.append(_bin)
            i += 1
            if i % 1000 == 0:
                print('loading lfw', i)

    # Save the paths and labels to a binary file
    with open(args.output, 'wb') as f:
        pickle.dump((lfw_bins, issame_list), f, protocol=pickle.HIGHEST_PROTOCOL)

if __name__ == "__main__":
    main()
