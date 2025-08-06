#!/bin/bash

set -e

# ───── กำหนดสี ─────
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
MAGENTA="\033[1;35m"
BLUE="\033[1;34m"
WHITE="\033[1;37m"
BOLD="\033[1m"
RESET="\033[0m"

# ───── หน้าแรก ─────
clear
echo -e "${CYAN}${BOLD}"
echo -e "╔═══════════════════════════════════════════╗"
echo -e "║                 🎧 ${MAGENTA}ALLDL${CYAN}${BOLD}                  ║"
echo -e "╚═══════════════════════════════════════════╝"
echo -e "${RESET}"
echo -e "${YELLOW}โครงการโอเพ่นซอร์สดาวน์โหลดเสียง/วิดีโอผ่าน yt-dlp${RESET}"
echo -e "${YELLOW}ผู้พัฒนา: ${GREEN}ninjamadeena${RESET}"
echo -e "${YELLOW}GitHub ผู้พัฒนา: ${BLUE}https://github.com/ninjamadeena${RESET}"
echo -e "${YELLOW}โครงการ ALLDL: ${BLUE}https://github.com/ninjamadeena/alldl-yt-dlp${RESET}"
sleep 5
clear

# ───── แบนเนอร์ติดตั้ง ─────
echo -e "${MAGENTA}${BOLD}"
echo -e "╔════════════════════════════════════════════════╗"
echo -e "║               🚀 เริ่มติดตั้ง ALLDL                 ║"
echo -e "╠════════════════════════════════════════════════╣"
echo -e "║   📥 ดาวน์โหลดวิดีโอ/เสียงจาก YouTube, TikTok ฯลฯ  ║"
echo -e "╚════════════════════════════════════════════════╝"
echo -e "${RESET}"
sleep 1

# ───── ฟังก์ชันติดตั้ง ─────
install_if_missing() {
    local cmd="$1"
    local pkg_termux="$2"
    local pkg_linux="$3"
    local name="$4"

    if ! command -v "$cmd" &>/dev/null; then
        echo -e "${RED}❌ ไม่พบ $name${RESET}"
        echo -e "${YELLOW}⏳ ติดตั้ง $name...${RESET}"
        if command -v pkg &>/dev/null; then
            pkg install -y "$pkg_termux"
        else
            sudo apt update && sudo apt install -y "$pkg_linux"
        fi
    else
        echo -e "${GREEN}✅ $name พร้อมใช้งานแล้ว${RESET}"
    fi
}

# ───── ตรวจสอบและติดตั้ง ─────
install_if_missing python3 python python3 "Python3"
install_if_missing pip3 python-pip python3-pip "pip3"
install_if_missing ffmpeg ffmpeg ffmpeg "ffmpeg"

# ───── ติดตั้ง yt-dlp ─────
if ! command -v yt-dlp &>/dev/null; then
    echo -e "${RED}❌ ไม่พบ yt-dlp${RESET}"
    echo -e "${YELLOW}📦 ติดตั้ง yt-dlp...${RESET}"
    pip3 install -U yt-dlp
else
    echo -e "${GREEN}✅ yt-dlp ติดตั้งแล้ว${RESET}"
fi

# ───── ตั้งค่า alldl.py ─────
SCRIPT_NAME="alldl.py"
TARGET_BIN="$PREFIX/bin/alldl"

if [ -f "$SCRIPT_NAME" ]; then
    echo -e "\n${CYAN}⚙️  ตั้งค่า alldl.py ให้รันได้...${RESET}"
    chmod +x "$SCRIPT_NAME"
    mv "$SCRIPT_NAME" "$TARGET_BIN"
    echo -e "${GREEN}✅ ติดตั้ง alldl สำเร็จที่ ${WHITE}$TARGET_BIN${RESET}"
else
    echo -e "${RED}⚠️ ไม่พบไฟล์ $SCRIPT_NAME ในไดเรกทอรีนี้${RESET}"
    exit 1
fi

# ───── ตรวจสอบหลังติดตั้ง ─────
echo -e "\n${YELLOW}🔍 ตรวจสอบความสมบูรณ์ของคำสั่ง...${RESET}"

for cmd in python3 pip3 ffmpeg yt-dlp alldl; do
    if command -v "$cmd" &>/dev/null; then
        echo -e "${GREEN}✅ $cmd ตรวจพบ${RESET}"
    else
        echo -e "${RED}❌ $cmd ไม่พบ${RESET}"
    fi
done

# ───── ย้ายไฟล์ถอนการติดตั้ง ─────
echo -e "\n${YELLOW}📦 ย้ายไฟล์ uninstallalldl.sh ไปที่ HOME...${RESET}"
mv ~/alldl-yt-dlp/uninstallalldl.sh ~/
echo -e "${GREEN}✅ ย้ายเรียบร้อยแล้ว${RESET}"

# ───── ลบไฟล์โฟลเดอร์ชั่วคราว ─────
echo -e "\n${YELLOW}🧹 ลบโฟลเดอร์ติดตั้ง alldl-yt-dlp...${RESET}"
rm -rf ~/alldl-yt-dlp
echo -e "${GREEN}✅ ลบเสร็จสิ้น${RESET}"
sleep 5

# ───── หน้าติดตั้งเสร็จ ─────
clear
echo -e "${BOLD}${CYAN}"
echo -e "╔════════════════════════════════════════════════╗"
echo -e "║         🎉 ${MAGENTA}ALLDL INSTALL COMPLETE${CYAN} 🎉           ║"
echo -e "╠════════════════════════════════════════════════╣"
echo -e "║ ✅ ติดตั้งเสร็จสมบูรณ์ พร้อมใช้งานแล้ว!                 ║"
echo -e "║ 🚀 เริ่มใช้งานด้วยคำสั่ง: ${GREEN}alldl${CYAN}                      ║"
echo -e "║ 🧹 ลบโปรแกรม: ${RED}bash uninstallalldl.sh${CYAN}           ║"
echo -e "║ 🎧 ขอบคุณที่ใช้โปรเจกต์โอเพ่นซอร์สจาก ninjamadeena    ║"
echo -e "╚════════════════════════════════════════════════╝"
echo -e "${RESET}"
