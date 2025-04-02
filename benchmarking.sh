#!/bin/bash
# download dataset
# wget https://huggingface.co/datasets/anon8231489123/ShareGPT_Vicuna_unfiltered/resolve/main/ShareGPT_V3_unfiltered_cleaned_split.json
MODEL_NAME="/mnt/opsstorage/xushuai/LLaMA-Factory/output/bi_agent_7b_0330_1"
NUM_PROMPTS=10
BACKEND="vllm"
DATASET_NAME="sharegpt"
DATASET_PATH="/mnt/opsstorage/xushuai/LLaMA-Factory/data/ShareGPT_V3_unfiltered_cleaned_split.json"
CUDA_VISIBLE_DEVICES=0,1 python vllm/benchmarks/benchmark_serving \
    --backend ${BACKEND} \
    --model ${MODEL_NAME} \
    --endpoint /v1/completions \
    --dataset-name ${DATASET_NAME} \
    --dataset-path ${DATASET_PATH} \
    --num-prompts ${NUM_PROMPTS} \
    --dtype half