#!/bin/bash

set -e

# ───── กำหนดสี ─────
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
BOLD="\033[1m"
RESET="\033[0m"

# ───── แสดงชื่อโปรแกรมและเครดิตก่อนติดตั้ง ────
clear
echo -e "${CYAN}${BOLD}"
echo "╔═══════════════════════════════════════════╗"
echo "║                 🎧 ALLDL                  ║"
echo "╚═══════════════════════════════════════════╝"
echo -e "${RESET}"

echo -e "${YELLOW} โครงการโอเพ่นซอร์สดาวน์โหลดเสียง/วิดีโอผ่าน yt-dlp${RESET}"
echo -e "${YELLOW} ผู้พัฒนา: ${CYAN}ninjamadeena${RESET}"
echo -e "${YELLOW} GitHub ผู้พัฒนา: ${CYAN}https://github.com/ninjamadeena${RESET}"
echo -e "${YELLOW} GitHub โครงการโอเพ่นซอร์: ${CYAN}https://github.com/ninjamadeena/alldl-yt-dlp${RESET}"
sleep 5

# ───── เคลียร์หน้าจอก่อนเริ่มจริง ─────
clear

# ───── โลโก้หน้าติดตั้ง ─────
echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════╗"
echo "║             🚀 ALLDL INSTALLER               ║"
echo "║          ดาวน์โหลดวิดีโอ/เสียงจาก yt-dlp         ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${RESET}"

echo -e "${YELLOW}🛠️  กำลังเริ่มการติดตั้ง ALLDL...${RESET}"
echo ""

# ───── ฟังก์ชันติดตั้ง ─────
install_if_missing() {
    local cmd="$1"
    local pkg_termux="$2"
    local pkg_linux="$3"
    local name="$4"

    if ! command -v "$cmd" &>/dev/null; then
        echo -e "${RED}❌ ไม่พบ $name${RESET}"
        echo -e "${YELLOW}📦 กำลังติดตั้ง $name...${RESET}"
        if command -v pkg &>/dev/null; then
            pkg install -y "$pkg_termux"
        else
            sudo apt update && sudo apt install -y "$pkg_linux"
        fi
    else
        echo -e "${GREEN}✅ พบ $name แล้ว${RESET}"
    fi
}

# ───── ตรวจสอบและติดตั้ง ─────
install_if_missing python3 python python3 "Python3"
install_if_missing pip3 python-pip python3-pip "pip3"
install_if_missing ffmpeg ffmpeg ffmpeg "ffmpeg"

# ───── yt-dlp ─────
if ! command -v yt-dlp &>/dev/null; then
    echo -e "${RED}❌ ไม่พบ yt-dlp${RESET}"
    echo -e "${YELLOW}📦 กำลังติดตั้ง yt-dlp...${RESET}"
    pip3 install -U yt-dlp
else
    echo -e "${GREEN}✅ พบ yt-dlp แล้ว${RESET}"
fi

# ───── ตั้งค่า alldl.py ─────
SCRIPT_NAME="alldl.py"
TARGET_BIN="$PREFIX/bin/alldl"

if [ -f "$SCRIPT_NAME" ]; then
    echo -e "\n${CYAN}⚙️  ตั้งค่า $SCRIPT_NAME ให้รันได้...${RESET}"
    chmod +x "$SCRIPT_NAME"
    mv "$SCRIPT_NAME" "$TARGET_BIN"
    echo -e "${GREEN}✅ ติดตั้ง alldl ที่ $TARGET_BIN เรียบร้อยแล้ว${RESET}"
else
    echo -e "${RED}⚠️ ไม่พบไฟล์ $SCRIPT_NAME ในไดเรกทอรีนี้${RESET}"
    exit 1
fi

# ───── ตรวจสอบหลังติดตั้ง ─────
echo -e "\n${YELLOW}🔍 ตรวจสอบความสมบูรณ์หลังติดตั้ง...${RESET}"

for cmd in python3 pip3 ffmpeg yt-dlp alldl; do
    if command -v "$cmd" &>/dev/null; then
        echo -e "${GREEN}✅ $cmd พร้อมใช้งาน${RESET}"
    else
        echo -e "${RED}❌ ไม่พบ $cmd${RESET}"
    fi
done
#───── ย้ายไฟล์ลบ ─────
echo -e "\n${YELLOW}🧹 กำลังย้ายไฟล์ลบ...${RESET}"
mv ~/alldl-yt-dlp/uninstallalldl.sh ~/
echo -e "${GREEN}✅ ย้ายเรียบร้อย${RESET}"

# ───── จบการติดตั้ง ─────
echo -e "\n${GREEN}${BOLD}🎉 การติดตั้งเสร็จสมบูรณ์!${RESET}"
echo -e "${CYAN}📌 พิมพ์คำสั่ง ${BOLD}alldl${RESET}${CYAN} เพื่อเริ่มใช้งาน${RESET}"
echo -e "${GREEN}📌 พิมพ์คำสั่ง bash uninstallalldl.sh เพื่อลบโปรแกรมทุกอย่างออกจากระบบได้${RESET}"
# ───── ล้างไฟล์ติดตั้ง ─────
echo -e "\n${YELLOW}🧹 ลบไฟล์ติดตั้งชั่วคราว...${RESET}"
rm -rf ~/alldl-yt-dlp
echo -e "${GREEN}✅ ลบเรียบร้อย${RESET}"
