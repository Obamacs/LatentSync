FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# 安装系统依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.10 python3.10-venv python3-pip \
        libgl1 \
        git \
        ffmpeg \
        wget \
        && rm -rf /var/lib/apt/lists/*

# 设置 python3.10 为默认
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

# 创建工作目录
WORKDIR /workspace

# 复制代码
COPY . .

# 安装 Python 依赖
RUN pip3 install --upgrade pip && \
    pip3 install -r requirements.txt

# 下载模型权重（可选，或在启动脚本中下载）
RUN pip3 install huggingface_hub && \
    mkdir -p checkpoints && \
    huggingface-cli download ByteDance/LatentSync-1.5 whisper/tiny.pt --local-dir checkpoints && \
    huggingface-cli download ByteDance/LatentSync-1.5 latentsync_unet.pt --local-dir checkpoints

# 默认启动命令（根据你的实际需求调整）
CMD ["python3", "gradio_app.py"]

