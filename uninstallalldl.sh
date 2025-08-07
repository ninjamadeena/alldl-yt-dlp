#!/bin/bash

set -e

# ───── กำหนดสี ─────
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
BOLD="\033[1m"
RESET="\033[0m"

# ───── เฮดเดอร์ ─────
clear
echo -e "${CYAN}${BOLD}"
echo "╔═══════════════════════════════════════════╗"
echo "║           🧹 ALLDL UNINSTALLER            ║"
echo "╚═══════════════════════════════════════════╝"
echo -e "${RESET}"
sleep 1

# ───── ฟังก์ชันถอนการติดตั้ง ─────
uninstall_program() {
    local cmd="$1"
    local pkg_termux="$2"
    local pkg_linux="$3"
    local name="$4"

    echo -e "\n${YELLOW}🔧 กำลังลบ $name...${RESET}"

    if command -v "$cmd" &>/dev/null; then
        if command -v pkg &>/dev/null; then
            pkg uninstall -y "$pkg_termux" && echo -e "${GREEN}✅ ลบ $name ด้วย pkg สำเร็จ${RESET}"
        else
            sudo apt remove -y "$pkg_linux" && echo -e "${GREEN}✅ ลบ $name ด้วย apt สำเร็จ${RESET}"
        fi
    else
        echo -e "${CYAN}ℹ️    ไม่พบ $name อยู่แล้ว${RESET}"
    fi

    # ตรวจสอบอีกครั้ง
    if ! command -v "$cmd" &>/dev/null; then
        echo -e "${GREEN}✔️ $name ถูกลบเรียบร้อยแล้ว${RESET}"
    else
        echo -e "${RED}❌ $name ยังอยู่ในระบบ${RESET}"
        echo -e "${YELLOW}📌 กรุณาลบ $name ด้วยตัวเอง เช่นใช้คำสั่ง:${RESET}"
        echo -e "${CYAN}    - pkg uninstall $pkg_termux${RESET}"
        echo -e "${CYAN}    - sudo apt remove $pkg_linux${RESET}"
    fi
}

# ───── ลบ alldl จาก bin ─────
echo -e "\n${YELLOW}🗑️ ลบไฟล์ alldl จาก bin...${RESET}"
if [ -z "$PREFIX" ]; then
    BIN_PATH="/usr/local/bin/alldl"
else
    BIN_PATH="$PREFIX/bin/alldl"
fi

if [ -f "$BIN_PATH" ]; then
    sudo rm -f "$BIN_PATH" || rm -f "$BIN_PATH"
    echo -e "${GREEN}✅ ลบ alldl จาก $BIN_PATH สำเร็จ${RESET}"
else
    echo -e "${CYAN}ℹ️    ไม่พบ alldl ใน $BIN_PATH${RESET}"
fi

# ───── ลบ yt-dlp ─────
uninstall_program "yt-dlp" "" "" "yt-dlp (pip uninstall)"
pip3 uninstall -y yt-dlp &>/dev/null || true
if ! command -v yt-dlp &>/dev/null; then
    echo -e "${GREEN}✔️ yt-dlp ถูกลบแล้ว (pip)${RESET}"
else
    echo -e "${RED}❌ yt-dlp ยังอยู่ในระบบ (pip)${RESET}"
    echo -e "${YELLOW}📌 กรุณาลบ yt-dlp ด้วยตนเอง: ${CYAN}pip3 uninstall yt-dlp${RESET}"
fi

# ───── ลบ FFmpeg และ Python ─────
uninstall_program "ffmpeg" "ffmpeg" "ffmpeg" "FFmpeg"
uninstall_program "python3" "python" "python3" "Python3"

# ───── ลบโฟลเดอร์ ALLDL ─────
echo -e "\n${YELLOW}🧹 ลบโฟลเดอร์ alldl-yt-dlp (ถ้ามี)...${RESET}"
rm -rf ~/alldl-yt-dlp && echo -e "${GREEN}✅ ลบโฟลเดอร์เรียบร้อย${RESET}" || echo -e "${CYAN}ℹ️ ไม่พบโฟลเดอร์นี้${RESET}"

# ───── สรุป ─────
echo -e "\n${CYAN}${BOLD}🎯 ตรวจสอบสถานะสุดท้าย:${RESET}"
NEED_MANUAL_UNINSTALL=false

for cmd in yt-dlp ffmpeg python3 alldl; do
    if command -v "$cmd" &>/dev/null; then
        echo -e "${RED}❌ $cmd ยังอยู่ในระบบ${RESET}"
        NEED_MANUAL_UNINSTALL=true

        # แนะนำวิธีลบตามแต่ละโปรแกรม
        case "$cmd" in
            yt-dlp)
                echo -e "${YELLOW}📌 กรุณาลบ $cmd ด้วยตนเอง เช่นใช้คำสั่ง:${RESET}"
                echo -e "${CYAN}    - pip3 uninstall yt-dlp${RESET}"
                ;;
            ffmpeg)
                echo -e "${YELLOW}📌 กรุณาลบ $cmd ด้วยตนเอง เช่นใช้คำสั่ง:${RESET}"
                echo -e "${CYAN}    - pkg uninstall ffmpeg${RESET}"
                echo -e "${CYAN}    - sudo apt remove ffmpeg${RESET}"
                ;;
            python3)
                echo -e "${YELLOW}📌 กรุณาลบ $cmd ด้วยตนเอง (แนะนำให้ระวัง เพราะ Python3 จำเป็นต่อระบบ)${RESET}"
                echo -e "${CYAN}    - pkg uninstall python${RESET}"
                echo -e "${CYAN}    - sudo apt remove python3${RESET}"
                ;;
            alldl)
                echo -e "${YELLOW}📌 กรุณาลบสคริปต์ alldl เอง เช่นใช้คำสั่ง:${RESET}"
                echo -e "${CYAN}    - rm -f /usr/local/bin/alldl${RESET}"
                echo -e "${CYAN}    - rm -f \$PREFIX/bin/alldl${RESET}"
                ;;
        esac
    else
        echo -e "${GREEN}✔️ $cmd ไม่อยู่ในระบบแล้ว${RESET}"
    fi
done

# ถ้ายังมีบางโปรแกรมค้างอยู่ หยุดการทำงานทันที
if [ "$NEED_MANUAL_UNINSTALL" = true ]; then
    echo -e "\n${RED}${BOLD}❌ การถอนการติดตั้งไม่สมบูรณ์ บางโปรแกรมยังคงอยู่ในระบบ${RESET}"
    echo -e "${YELLOW}⚠️  กรุณาลบโปรแกรมที่เหลืออยู่ด้วยตนเองก่อนดำเนินการต่อ${RESET}"
    exit 1
fi
sleep 5
# ───── กรอบสรุปการถอนการติดตั้ง ─────
clear
echo -e "${CYAN}${BOLD}"
echo "╔═══════════════════════════════════════════╗"
echo "║      ✅  ALLDL UNINSTALLER COMPLETE!      ║"
echo "╚═══════════════════════════════════════════╝"
echo -e "${RESET}"

# ───── ลบตัวถอนการติดตั้งตัวเอง ─────
rm -- "$0"
