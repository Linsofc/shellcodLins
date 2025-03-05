#!/bin/bash

# Warna ANSI untuk output yang lebih menarik
BLUE="\e[1;34m"
CYAN="\e[1;36m"
YELLOW="\e[1;33m"
GREEN="\e[1;32m"
RED="\e[1;31m"
RESET="\e[0m"

# Periksa apakah script dijalankan sebagai root
if [[ $EUID -ne 0 ]]; then
    echo -e "${YELLOW}[WARNING] Tidak berjalan sebagai root! Beberapa fitur mungkin tidak tersedia.${RESET}"
    SUDO=""
else
    SUDO="sudo"
fi

# Update dan install dependensi jika diperlukan
echo -e "${BLUE}[INFO] Memeriksa dependensi...${RESET}"

for pkg in curl neofetch; do
    if ! command -v "$pkg" &> /dev/null; then
        echo -e "${YELLOW}[WARNING] $pkg tidak ditemukan, mencoba menginstall...${RESET}"
        if [[ -n "$SUDO" ]]; then
            $SUDO apt update -qq && $SUDO apt install -y -qq "$pkg" || {
                echo -e "${RED}[ERROR] Gagal menginstall $pkg.${RESET}"
            }
        else
            echo -e "${RED}[ERROR] $pkg tidak terpasang dan tidak dapat diinstall tanpa root.${RESET}"
        fi
    fi
done

# Bersihkan layar sebelum menampilkan banner
clear

# Menampilkan informasi sistem dengan neofetch jika tersedia
if command -v neofetch &> /dev/null; then
    neofetch --ascii_distro Debian --disable title uptime shell resolution de wm de_theme wm_theme icons terminal terminal_font gpu disk
else
    echo -e "${YELLOW}[WARNING] Neofetch tidak ditemukan, melewati tampilan sistem.${RESET}"
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
