#!/bin/bash

# Warna ANSI untuk output yang lebih menarik
BLUE="\e[1;34m"
CYAN="\e[1;36m"
YELLOW="\e[1;33m"
GREEN="\e[1;32m"
RED="\e[1;31m"
RESET="\e[0m"

# Update dan install paket yang dibutuhkan
echo -e "${BLUE}[INFO] Memperbarui paket dan menginstal dependensi...${RESET}"
apt update && apt install -y curl figlet lolcat nodejs npm yarn imagemagick python3 ffmpeg speedtest-cli pnpm pm2

# Bersihkan layar sebelum menampilkan banner
clear

# Menampilkan banner ASCII dengan warna
echo -e "${CYAN}"
figlet "Node.js 19" | lolcat
echo -e "${RESET}"

# Menampilkan informasi sistem
echo -e "${YELLOW}[ NODE V.19 BERHASIL DI INSTALL ]${RESET}"
echo -e "${GREEN}SUDAH TERINSTALL:${RESET} YARN, IMAGEMAGICK, PYTHON, FFMPEG, SPEEDTEST, PNPM, PM2, NODEMON, TS-NODE, PUPPETEER"
echo -e "${RED}NB: HARAP BERHATI-HATI DALAM MEMBELI PANEL${RESET}"
echo -e "${CYAN}LIST PANEL LEGAL:${RESET}"
echo -e "1. Linsofc ()"
echo -e "${RED}SELAIN PANEL TERSEBUT, MERUPAKAN AKSES ILEGAL DAN DATA ANDA TIDAK TERJAMIN KEAMANANNYA!${RESET}"
echo -e "${BLUE}INFO: WHATSAPP 081911317205${RESET}"

# Cek apakah variabel PTEROIGNORE_URL tersedia dan mengunduh file jika ada
if [[ -n "$PTEROIGNORE_URL" ]]; then
    echo -e "${BLUE}[INFO] Mengunduh file .pteroignore...${RESET}"
    curl -sSL "$PTEROIGNORE_URL" -o /home/container/.pteroignore
else
    echo -e "${RED}[WARNING] PTEROIGNORE_URL tidak disediakan, melewati pengunduhan...${RESET}"
fi

# Jalankan perintah utama
echo -e "${BLUE}[INFO] Menjalankan aplikasi Node.js...${RESET}"
