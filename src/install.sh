#!/bin/bash

# Update dan install paket yang dibutuhkan
echo -e "\e[1;34m[INFO] Memperbarui paket dan menginstal dependensi...\e[0m"
apt update && apt install -y curl figlet lolcat nodejs npm yarn imagemagick python3 ffmpeg speedtest-cli pnpm pm2

# Bersihkan layar sebelum menampilkan banner
clear

# Menampilkan banner ASCII dengan warna
echo -e "\e[1;36m"
figlet "Node.js 19" | lolcat
echo -e "\e[0m"

# Menampilkan informasi sistem
echo -e "\e[1;33m[ NODE V.19 BERHASIL DI INSTALL ]\e[0m"
echo -e "\e[1;32mSUDAH TERINSTALL:\e[0m YARN, IMAGEMAGICK, PYTHON, FFMPEG, SPEEDTEST, PNPM, PM2, NODEMON, TS-NODE, PUPPETEER"
echo -e "\e[1;31mNB: HARAP BERHATI-HATI DALAM MEMBELI PANEL\e[0m"
echo -e "\e[1;36mLIST PANEL LEGAL:\e[0m"
echo -e "1. Linsofc (panel.kangyud.tech)"
echo -e "\e[1;31mSELAIN PANEL TERSEBUT, MERUPAKAN AKSES ILEGAL DAN DATA ANDA TIDAK TERJAMIN KEAMANANNYA!\e[0m"
echo -e "\e[1;34mINFO: WHATSAPP 081911317205\e[0m"

# Cek apakah PTEROIGNORE_URL tersedia
if [ -n "$PTEROIGNORE_URL" ]; then
    echo -e "\e[1;34m[INFO] Mengunduh file .pteroignore...\e[0m"
    curl -sSL "$PTEROIGNORE_URL" -o /home/container/.pteroignore
else
    echo -e "\e[1;31m[WARNING] PTEROIGNORE_URL tidak disediakan, melewati pengunduhan...\e[0m"
fi

# Jalankan perintah utama
echo -e "\e[1;34m[INFO] Menjalankan aplikasi Node.js...\e[0m"
