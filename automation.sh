# #!/bin/bash
# initial_p=0.0
# initial_m=0.5
# initial_h=0.22
# num_iterations=2
# for ((p_iter=0; p_iter<$num_iterations; p_iter++)); do
#     p=$(awk "BEGIN { print $initial_p + 0.3*$p_iter }")
#     for ((m_iter=0; m_iter<$num_iterations; m_iter++)); do
#         m=$(awk "BEGIN { print $initial_m + 0.25*$m_iter }")
#         for ((h_iter=0; h_iter<$num_iterations; h_iter++)); do
#             h=$(awk "BEGIN { print $initial_h + 0.44*$h_iter }")
#             output_file="output_p${p}_m${m}_h${h}.log"
#             python3 main.py \
#             --data_root ./train_dataset/ \
#             --train_data_path adaface_images \
#             --val_data_path adaface_images \
#             --prefix ir101_ms1mv2_adaface_finetune_stage1 \
#             --gpus 1 \
#             --use_16bit \
#             --arch ir_101 \
#             --batch_size 2048 \
#             --num_workers 16 \
#             --epochs 26 \
#             --lr_milestones 12,20,24 \
#             --lr 0.1 \
#             --head adaface \
#             --use_wandb \
#             --m $m \
#             --h $h \
#             --low_res_augmentation_prob $p \
#             --crop_augmentation_prob $p \
#             --photometric_augmentation_prob $p \
#             --freeze_model True \
#             --start_from_model_statedict ./pretrained/adaface_ir101_ms1mv2.ckpt \
#             --custom_num_class 2358 \
#             >> $output_file
#             lastCkpt=$(find experiments -name last.ckpt)
#             if [ -n "$lastCkpt" ]; then
#                 python3 main.py \
#                 --data_root ./train_dataset/ \
#                 --train_data_path adaface_images \
#                 --val_data_path adaface_images \
#                 --prefix ir101_ms1mv2_adaface_finetune_stage2 \
#                 --gpus 1 \
#                 --use_16bit \
#                 --arch ir_101 \
#                 --batch_size 210 \
#                 --num_workers 16 \
#                 --epochs 52 \
#                 --lr_milestones 12,20,24 \
#                 --lr 0.1 \
#                 --head adaface \
#                 --use_wandb \
#                 --m $m \
#                 --h $h \
#                 --low_res_augmentation_prob $p \
#                 --crop_augmentation_prob $p \
#                 --photometric_augmentation_prob $p \
#                 --resume_from_checkpoint "$lastCkpt" \
#                 --custom_num_class 2358 \
#                 >> $output_file  # Append output to the file
#                 rm "$lastCkpt"
#                 echo "-------------------------------------" >> $output_file
#             fi
#         done
#     done
# done

m=0.4 
h=0.333
p=0.2
lr=0.05
fzs=(0)
optimizers=(sgd)

mkdir -p ./ckpts

for optimizer in "${optimizers[@]}"; do
    for fz in "${fzs[@]}"; do
        output_file="output_lr${lr}_p${p}_m${m}_h${h}_dogFace_${optimizer}_${fz}Freeze.log"
        ckpt_file_name="./ckpts/$(basename "$output_file" .log).ckpt"
        python3 main.py \
        --data_root ./train_dataset/ \
        --train_data_path dogFace_112 \
        --val_data_path dogFace_112 \
        --prefix ir101_ms1mv2_adaface_dogFace_${optimizer}_${fz}Freeze_lr${lr}_p${p}_m${m}_h${h} \
        --gpus 1 \
        --use_16bit \
        --arch ir_101 \
        --batch_size 2048 \
        --num_workers 16 \
        --epochs 10 \
        --lr_milestones 5,12,24 \
        --lr_gamma 0.05 \
        --lr $lr \
        --head adaface \
        --use_wandb \
        --optimizer $optimizer \
        --m $m \
        --h $h \
        --low_res_augmentation_prob $p \
        --crop_augmentation_prob $p \
        --photometric_augmentation_prob $p \
        --freeze_model True \
        --start_from_model_statedict ./pretrained/adaface_ir101_ms1mv2.ckpt \
        --custom_num_class 984 \
        --swap_color_channel \
        >> $output_file
        lastCkpt=$(find experiments -name last.ckpt)
        if [ -n "$lastCkpt" ]; then
            python3 main.py \
            --data_root ./train_dataset/ \
            --train_data_path dogFace_112 \
            --val_data_path dogFace_112 \
            --prefix ir101_ms1mv2_adaface_dogFace_${optimizer}_${fz}Freeze_lr${lr}_p${p}_m${m}_h${h} \
            --gpus 1 \
            --use_16bit \
            --arch ir_101 \
            --batch_size 200 \
            --num_workers 16 \
            --epochs 30 \
            --lr_milestones 5,12,24 \
            --lr_gamma 0.05 \
            --lr $lr \
            --head adaface \
            --use_wandb \
            --optimizer $optimizer \
            --m $m \
            --h $h \
            --low_res_augmentation_prob $p \
            --crop_augmentation_prob $p \
            --photometric_augmentation_prob $p \
            --freeze_model $fz \
            --resume_from_checkpoint "$lastCkpt" \
            --custom_num_class 984 \
            --swap_color_channel \
            >> $output_file 
            mv "$lastCkpt" "$ckpt_file_name"
            echo "Moved checkpoint to $ckpt_file_name" >> $output_file
            echo "-------------------------------------" >> $output_file
        fi
    done
done