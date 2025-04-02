### Download Model

```bash
huggingface-cli download \
    deepseek-ai/DeepSeek-R1-Distill-Qwen-7B \
    --local-dir /mnt/opsstorage/xushuai/models/DeepSeek-R1-Distill-Qwen-7B \
    --local-dir-use-symlinks False
```

### Chat

```bash
CUDA_VISIBLE_DEVICES=0,1 llamafactory-cli chat \
    --model_name_or_path /mnt/opsstorage/xushuai/models/DeepSeek-R1-Distill-Qwen-7B \
    --adapter_name_or_path ./saves/bi_agent_7b_0330_1  \
    --template deepseek3 \
    --finetuning_type lora
```

### Deploy

#### 后台运行 vLLM 服务

```bash
CUDA_VISIBLE_DEVICES=0,1 nohup python -m vllm.entrypoints.openai.api_server \
  --model /mnt/opsstorage/xushuai/LLaMA-Factory/output/bi_agent_7b_0330_1 \
  --served-model-name deepseek_7b \
  --tensor-parallel-size 2 \
  --host 0.0.0.0 \
  --port 8000 \
  --gpu-memory-utilization 0.99 \
  --load-format safetensors \
  --max-model-len 32768 \
  --max-seq-len-to-capture 32768 \
  --dtype half \
  > vllm.log 2>&1 &
```

#### 测试部署接口

> 172.18.36.104

```bash
curl -X POST "http://0.0.0.0:8000/v1/chat/completions" \
	-H "Content-Type: application/json" \
	--data '{
		"model": "deepseek_7b",
		"messages": [
			{
				"role": "user",
				"content": "你是谁"
			}
		]
	}'
```

> 查看端口占用进程: lsof -i :8000
