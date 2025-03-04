FROM vllm/vllm-openai:latest

# Enable HF Hub Transfer
ENV HF_HUB_ENABLE_HF_TRANSFER 1

# Expose port 80
EXPOSE 80

# Entrypoint with API key
ENTRYPOINT ["python3", "-m", "vllm.entrypoints.openai.api_server", \
            # name of the model
           "--model", "deepseek-ai/DeepSeek-R1-Distill-Qwen-1.5B", \
           # set the data type to bfloat16 - requires ~1400GB GPU memory
           "--dtype", "bfloat16", \
           "--trust-remote-code", \
           # below runs the model on 8 GPUs
           #    "--tensor-parallel-size","8", \
           # Maximum number of tokens, can lead to OOM if overestimated
           "--max-model-len", "4096", \
           # Port on which to run the vLLM server
           "--port", "80", \
           # CPU offload in GB. Need this as 8 H100s are not sufficient
           "--cpu-offload-gb", "4", \
           "--gpu-memory-utilization", "0.95", \
           # API key for authentication to the server stored in Tensorfuse secrets
           "--api-key", "${VLLM_API_KEY}"]
