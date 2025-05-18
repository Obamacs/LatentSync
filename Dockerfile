FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime

WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    git \
    wget \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

# 复制仓库文件
COPY . /app/

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 下载检查点
RUN mkdir -p checkpoints/whisper && \
    wget -O checkpoints/latentsync_unet.pt https://huggingface.co/ByteDance/LatentSync-1.5/resolve/main/latentsync_unet.pt && \
    wget -O checkpoints/whisper/tiny.pt https://huggingface.co/ByteDance/LatentSync-1.5/resolve/main/whisper/tiny.pt && \
    wget -O checkpoints/stable_syncnet.pt https://huggingface.co/ByteDance/LatentSync-1.5/resolve/main/stable_syncnet.pt

# 设置环境变量
ENV PYTHONPATH=/app

# 默认端口（如果使用Gradio）
EXPOSE 7860

# 默认运行Gradio应用
CMD ["python", "gradio_app.py"]
