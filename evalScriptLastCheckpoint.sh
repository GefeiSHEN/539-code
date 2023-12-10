python main.py \
    --data_root data \
    --train_data_path dogFace_112 \
    --val_data_path dogFace_112 \
    --prefix adaface_ir101_ms1mv2 \
    --gpus 1 \
    --use_16bit \
    --start_from_model_statedict "./experiments/ir101_dogFace_transferLearning_12-09_0/epoch=32-step=4191.ckpt" \
    --arch ir_101 \
    --evaluate \
    --use_mxrecord \
    --custom_num_class 984
