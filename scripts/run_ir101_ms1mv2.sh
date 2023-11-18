
python3 main.py \
    --data_root ./train_dataset/ \
    --train_data_path adaface_images \
    --val_data_path adaface_images \
    --prefix ir101_ms1mv2_adaface_finetune \
    --gpus 1 \
    --use_16bit \
    --arch ir_101 \
    --batch_size 200 \
    --num_workers 16 \
    --epochs 26 \
    --lr_milestones 12,20,24 \
    --lr 0.1 \
    --head adaface \
    --m 0.4 \
    --h 0.333 \
    --low_res_augmentation_prob 0.2 \
    --crop_augmentation_prob 0.2 \
    --photometric_augmentation_prob 0.2 \
    --resume_from_checkpoint ./pretrained/adaface_ir101_ms1mv2.ckpt \
    --custom_num_class 2370	

