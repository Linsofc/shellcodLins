#!/bin/bash

# Warna ANSI untuk output yang lebih menarik
BLUE="\e[1;34m"
CYAN="\e[1;36m"
YELLOW="\e[1;33m"
GREEN="\e[1;32m"
RED="\e[1;31m"
RESET="\e[0m"

# Pastikan script dijalankan sebagai root

# Update dan install dependensi yang dibutuhkan
echo -e "\e[1;34m[INFO] Memperbarui paket dan menginstal dependensi...\e[0m"
apt update && apt install -y curl rxfetch figlet lolcat nodejs npm yarn imagemagick python3 ffmpeg speedtest-cli pnpm pm2

# Bersihkan layar sebelum menampilkan banner
clear

# Menampilkan informasi sistem dengan rxfetch jika tersedia
if command -v rxfetch &> /dev/null; then
    rxfetch
else
    echo -e "${YELLOW}[WARNING] rxfetch tidak ditemukan, melewati tampilan sistem.${RESET}"
fi

# Menampilkan informasi status
echo -e "${GREEN}============================================${RESET}"
echo -e "${GREEN}[ NodeJs Berhasil Diinstall ]${RESET}"
echo -e "${CYAN}Created By Lins Official${RESET}"
echo -e "${RED}=======[ SOSMED RESMI LINS OFFICIAL ]=======${RESET}"
echo -e "${RED}YouTube:${RESET} https://youtube.com/@LinsOfficiall"
echo -e "${GREEN}WhatsApp:${RESET} +6285190090045"
echo -e "${BLUE}Saluran WhatsApp:${RESET} https://whatsapp.com/channel/0029VaeQHirJ93waiykxjF2L"
echo -e "${YELLOW}Website Resmi:${RESET} https://linsofc.github.io"
echo -e "${RED}============================================${RESET}"
echo -e "${RED}Harap berhati-hati terhadap akun palsu! Daftar di atas adalah akun resmi Lins Official.${RESET}"
echo -e "${BLUE}© 2025${RESET}"
echo -e "${GREEN}============================================${RESET}"

# Menjalankan Node.js (Jika Terpasang)
if command -v node &> /dev/null; then
    echo -e "${BLUE}[Linsofc] Sedang Menjalankan Aplikasi Nodejs...${RESET}"
else
    echo -e "${RED}[ERROR] Node.js tidak ditemukan, pastikan sudah terinstall.${RESET}"
fi
