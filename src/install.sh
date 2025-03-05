#!/bin/bash

# Warna ANSI untuk output yang lebih menarik
BLUE="\e[1;34m"
CYAN="\e[1;36m"
YELLOW="\e[1;33m"
GREEN="\e[1;32m"
RED="\e[1;31m"
RESET="\e[0m"

# Pastikan script dijalankan sebagai root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[ERROR] Jalankan script ini sebagai root atau gunakan sudo.${RESET}"
    exit 1
fi

# Update dan install dependensi yang dibutuhkan
echo -e "${BLUE}[INFO] Memeriksa dependensi ...${RESET}"
apt update -qq && apt install -y -qq curl neofetch || {
    echo -e "${RED}[ERROR] Gagal menginstall dependensi.${RESET}"
    exit 1
}

# Bersihkan layar sebelum menampilkan banner
clear

# Menampilkan informasi sistem dengan neofetch
echo -e "${CYAN}[INFO] Menampilkan informasi sistem...${RESET}"
neofetch --ascii_distro Debian --disable title uptime shell resolution de wm de_theme wm_theme icons terminal terminal_font gpu disk

# Tunggu sejenak agar informasi sistem terbaca sebelum lanjut
sleep 2
echo -e "\n"

# Lanjutkan ke tampilan informasi Lins Official
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

# Jalankan perintah utama
echo -e "${BLUE}[Linsofc] Sedang Menjalankan Aplikasi Nodejs...${RESET}"
