#!/bin/bash
set -e  # 出错即停止执行

# ========= 配置参数 =========
MODEL_NAME=DeepSeek-R1-Distill-Qwen-7B
MODEL_PATH=/mnt/opsstorage/xushuai/models/$MODEL_NAME

DATA_VERSION=0330_1
DATASET_NAME=bi_agent
DATASET_DIR=./data_$DATA_VERSION

OUTPUT_DIR=./saves/${DATASET_NAME}_7b_$DATA_VERSION
EXPORT_DIR=./output/${DATASET_NAME}_7b_$DATA_VERSION

TEMPLATE=deepseek3
BATCH_SIZE=2
GRAD_ACC_STEPS=8
LR=1e-4
NUM_EPOCHS=4
WARMUP_RATIO=0.1
LOGGING_STEPS=1
SAVE_STEPS=128
NUM_WORKERS=16

# ========= 启动训练 =========
CUDA_VISIBLE_DEVICES=0,1 llamafactory-cli train \
    --stage sft \
    --do_train \
    --model_name_or_path $MODEL_PATH \
    --dataset $DATASET_NAME \
    --dataset_dir $DATASET_DIR \
    --template $TEMPLATE \
    --finetuning_type lora \
    --output_dir $OUTPUT_DIR \
    --overwrite_cache \
    --overwrite_output_dir \
    --preprocessing_num_workers $NUM_WORKERS \
    --per_device_train_batch_size $BATCH_SIZE \
    --gradient_accumulation_steps $GRAD_ACC_STEPS \
    --lr_scheduler_type cosine \
    --logging_steps $LOGGING_STEPS \
    --warmup_ratio $WARMUP_RATIO \
    --num_train_epochs $NUM_EPOCHS \
    --save_steps $SAVE_STEPS \
    --learning_rate $LR \
    --plot_loss \
    --fp16

# ========= 导出模型 =========
CUDA_VISIBLE_DEVICES=0,1 llamafactory-cli export \
    --model_name_or_path $MODEL_PATH \
    --adapter_name_or_path $OUTPUT_DIR \
    --template $TEMPLATE \
    --finetuning_type lora \
    --export_dir $EXPORT_DIR \
    --export_size 10 \
    --export_device auto \
    --export_legacy_format False
