# Dog Face Recognition Based on AdaFace

This project finetuned a model based on AdaFace to recognize faces of individual dogs. The model is finetuned on the [AdaFace R100 MS1MV2](https://github.com/mk-minchul/AdaFace) base model with images from [TheDogFaceNet Dataset1](https://github.com/GuillaumeMougeot/DogFaceNet/releases/tag/dataset).

#### Author: Gefei Shen, Mark Tervo, Ryan Usher

## Modifications made to AdaFace code for this project
- Created novel scripts for partitioning and resizing the DogFaceNet dataset, and created scripts for creating labeled pairs for validation and testing datasets
- Created scripts to aggregate images and pairing information for the validation and testing datasets into binary files, one binary file for the validation set, and one binary file for the testing set
- Modified AdaFace code to accept the DogFaceNet Dataset for both training, validation, and testing
- Modified the AdaFace code to allow freezing and unfreezing the model to facilitate transfer learning
- Modified the AdaFace code so it logs the training loss to wandb during training
- Modified the AdaFace code so it reports the TP, TF, NP, and NF metrics during testing
- Created a hyperparameter search bash shell script
- Created scipts for adding shadows to CPLFW images

## Preprocessing
Images from the Dog-FaceNet Dataset were resized, partitioned into 70/15/15 distinct training, validation, and testing sets, and transformed into unique pairs (image1, image2, label 0-different dogs 1-same dog). Samples are then loaded into a binary file.

## Training
We enhanced the AdaFace model using transfer learning in two stages: first by training only the classification head with the model frozen, and then by training the entire model. We used a bash script for grid search hyperparameter optimization and utilized weights and bias to store results from all experiments.

## Evaluation 
In the final evaluation phase, we used a holdout dataset and modified AdaFace code to report detailed metrics like true positives and negatives, enhancing the original code's limited performance reporting.

## Results
The finetuned model significantly improved the dog face facial recoginition performance from 79.77% to 91.63%.
