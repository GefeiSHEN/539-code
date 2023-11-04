# Installation Steps:

Note: As a general guideline, always refer to [AdaFace](https://github.com/mk-minchul/AdaFace/blob/master/README_TRAIN.md)

## Steps
1. Clone this repo, cd to this repo.
2. Run the following:
```
conda create --name adaface pytorch==1.8.0 torchvision==0.9.0 cudatoolkit=10.2 -c pytorch
conda activate adaface
conda install scikit-image matplotlib pandas scikit-learn 
pip install -r requirements.txt
```
3. If you encounter an error during the above step: "Error while installing PyTorch using pip - cannot build wheel", run the following to install pytorch
```
conda install pytorch==1.8.0 torchvision==0.9.0 torchaudio==0.8.0 cudatoolkit=10.2 -c pytorch
```
4. Install OpenCV:
```
conda install -c conda-forge opencv
```
