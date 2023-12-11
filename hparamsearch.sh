ms=(0.4 0.5 0.75)
hs=(0.22 0.333 0.66)
ps=(0 0.2 0.3)
lr=0.05
fzs=(0)
momentums=(0.93)
t_alphas=(0.01)
optimizers=(sgd adam)

mkdir -p ./ckpts
mkdir -p ./logs

# counter=0
for t_alpha in "${t_alphas[@]}"; do
    for momentum in "${momentums[@]}"; do
        for optimizer in "${optimizers[@]}"; do
            for fz in "${fzs[@]}"; do
                for m in "${ms[@]}"; do
                    for h in "${hs[@]}"; do
                        for p in "${ps[@]}"; do
                            # ((counter++))
                            # if [ $counter -lt 18 ]; then
                            #     continue
                            # fi
                            output_file="./logs/lr${lr}_p${p}_m${m}_h${h}_dogFace_${optimizer}_Freeze${fz}_momentum${momentum}_alpha${t_alpha}.log"
                            ckpt_file_name="./ckpts/$(basename "$output_file" .log).ckpt"
                            python3 main.py \
                            --data_root ./train_dataset/ \
                            --train_data_path dogFace_112 \
                            --val_data_path dogFace_112 \
                            --prefix ir101_ms1mv2_dogFace_${optimizer}_${fz}Freeze_lr${lr}_p${p}_m${m}_h${h}_momentum${momentum}_alpha${t_alpha} \
                            --gpus 1 \
                            --use_16bit \
                            --arch ir_101 \
                            --batch_size 2048 \
                            --num_workers 16 \
                            --epochs 10 \
                            --lr_milestones 5,12,24 \
                            --lr_gamma 0.1 \
                            --lr $lr \
                            --head adaface \
                            --use_wandb \
                            --optimizer $optimizer \
                            --momentum $momentum \
                            --t_alpha $t_alpha \
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
                                --prefix ir101_ms1mv2_dogFace_${optimizer}_${fz}Freeze_lr${lr}_p${p}_m${m}_h${h}_momentum${momentum}_alpha${t_alpha} \
                                --gpus 1 \
                                --use_16bit \
                                --arch ir_101 \
                                --batch_size 200 \
                                --num_workers 16 \
                                --epochs 35 \
                                --lr_milestones 5,12,24 \
                                --lr_gamma 0.1 \
                                --lr $lr \
                                --head adaface \
                                --use_wandb \
                                --optimizer $optimizer \
                                --momentum $momentum \
                                --t_alpha $t_alpha \
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
                done
            done
        done
    done
done