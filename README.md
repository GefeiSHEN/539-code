# Installation Steps:

Note: As a general guideline, always refer to [AdaFace](https://github.com/mk-minchul/AdaFace/blob/master/README_TRAIN.md) for instructions for installing dependencies

# Modifications made to AdaFace code for this project
- Created novel scripts for partitioning and resizing the DogFaceNet dataset, and created scripts for creating labeled pairs for validation and testing datasets
- Created scripts to aggregate images and pairing information for the validation and testing datasets into binary files, one binary file for the validation set, and one binary file for the testing set
- Modified AdaFace code to accept the DogFaceNet Dataset for both training, validation, and testing
- Modified the AdaFace code to allow freezing and unfreezing the model to facilitate transfer learning
- Modified the AdaFace code so it reports the TP, TF, NP, and NF metrics during testing
- Created a hyperparameter search bash shell script
- Created scipts for adding shadows to CPLFW images
