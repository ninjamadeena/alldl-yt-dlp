#!/bin/bash

set -e

echo "🛠️ เริ่มติดตั้ง ALLDL..."

# ตรวจสอบและติดตั้ง Python3
if ! command -v python3 &>/dev/null; then
    echo "📦 ติดตั้ง Python3..."
    if command -v pkg &>/dev/null; then
        pkg install -y python
    else
        sudo apt update && sudo apt install -y python3
    fi
else
    echo "✅ พบ Python3 แล้ว"
fi

# ตรวจสอบและติดตั้ง pip3
if ! command -v pip3 &>/dev/null; then
    echo "📦 ติดตั้ง pip3..."
    if command -v pkg &>/dev/null; then
        pkg install -y python-pip
    else
        sudo apt install -y python3-pip
    fi
else
    echo "✅ พบ pip3 แล้ว"
fi

# ตรวจสอบและติดตั้ง ffmpeg
if ! command -v ffmpeg &>/dev/null; then
    echo "📦 ติดตั้ง ffmpeg..."
    if command -v pkg &>/dev/null; then
        pkg install -y ffmpeg
    else
        sudo apt install -y ffmpeg
    fi
else
    echo "✅ พบ ffmpeg แล้ว"
fi

# ตรวจสอบและติดตั้ง yt-dlp
if ! command -v yt-dlp &>/dev/null; then
    echo "📦 ติดตั้ง yt-dlp..."
    pip3 install -U yt-dlp
else
    echo "✅ พบ yt-dlp แล้ว"
fi

# ตั้งชื่อไฟล์ Python และย้ายไป PATH
SCRIPT_NAME="alldl.py"
TARGET_BIN="$PREFIX/bin/alldl"

echo "⚙️ ตั้งค่าไฟล์ $SCRIPT_NAME ให้รันได้..."

chmod +x "$SCRIPT_NAME"
mv "$SCRIPT_NAME" "$TARGET_BIN"

echo -e "\n✅ ติดตั้งเสร็จสมบูรณ์แล้ว!"
echo "📌 ตอนนี้คุณสามารถเรียกใช้โปรแกรมได้ด้วยคำสั่ง:"
echo "   alldl"
rm -rf alldl-yt-dlp
