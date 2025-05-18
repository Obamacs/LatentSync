# 使用官方 CUDA 镜像，适合 PyTorch 2.x 和 GPU 环境
FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# 防止交互式安装
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# 安装系统依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.10 python3.10-venv python3-pip \
        git \
        ffmpeg \
        libgl1 \
        gcc \
        python3-dev \
        wget \
    && rm -rf /var/lib/apt/lists/*

# 设置 python3.10 为默认
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1

# 设置工作目录
WORKDIR /workspace

# 复制 requirements.txt 并安装依赖
COPY requirements.txt .

# 使用国内源加速，可选
RUN pip3 install --upgrade pip && \
    pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 复制项目所有文件
COPY . .

# 可选：下载模型权重（如有需要可自定义）
# RUN python3 scripts/download_model.py

# 默认启动命令（根据你的实际入口脚本调整）
CMD ["python3", "gradio_app.py"]

