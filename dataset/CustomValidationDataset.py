import torch
from torch.utils.data import Dataset
import os
import numpy as np
from PIL import Image

class CustomValidationDataset(Dataset):
    def __init__(self, root, swap_color_channel, output_dir, transform=None):
        self.root = root
        self.swap_color_channel = swap_color_channel
        self.output_dir = output_dir
        self.transform = transform
        self.samples = []  
        self.classes, self.class_to_idx = self._find_classes(self.root)
        self._load_data()

    def _load_data(self):
        for target_class in sorted(self.class_to_idx.keys()):
            class_index = self.class_to_idx[target_class]
            target_dir = os.path.join(self.root, target_class)
            if not os.path.isdir(target_dir):
                continue
            for root, _, fnames in sorted(os.walk(target_dir)):
                for fname in sorted(fnames):
                    path = os.path.join(root, fname)
                    item = (path, class_index)
                    self.samples.append(item)

    def _find_classes(self, dir):
        classes = [d.name for d in os.scandir(dir) if d.is_dir()]
        classes.sort()
        class_to_idx = {cls_name: i for i, cls_name in enumerate(classes)}
        return classes, class_to_idx

    def __getitem__(self, index):
        path, target = self.samples[index]
        sample = Image.open(path).convert('RGB')

        if self.swap_color_channel:
            # Swap RGB to BGR if sample is in RGB
            # we need sample in BGR
            sample = Image.fromarray(np.asarray(sample)[:, :, ::-1])

        if self.transform is not None:
            sample = self.transform(sample)

        return sample, target

    def __len__(self):
        return len(self.samples)
