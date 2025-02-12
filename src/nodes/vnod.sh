#!/bin/bash

# Warna untuk output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m' # Reset warna

# Tampilan ASCII Art + Credit
clear
echo -e "${CYAN}"
echo "===================================="
echo "      🔥 Lins Official 🔥"
echo "  Auto Renew SSL & Restart Nodes"
echo "===================================="
echo -e "${NC}"

# Verifikasi Token
read -p "Masukkan token akses: " USER_TOKEN
if [[ "$USER_TOKEN" != "xlinsxsubs" ]]; then
    echo -e "${RED}Token salah! Akses ditolak.${NC}"
    exit 1
fi

echo -e "${GREEN}Token valid! Memulai proses...${NC}"
sleep 1

echo -e "${YELLOW}➤ Memeriksa sertifikat yang ada...${NC}"
certbot certificates

echo -e "${RED}➤ Menghentikan layanan Nginx...${NC}"
systemctl stop nginx

echo -e "${GREEN}➤ Memperbarui sertifikat SSL...${NC}"
certbot renew

echo -e "${RED}➤ Memulai ulang layanan Nginx...${NC}"
systemctl restart nginx

echo -e "${YELLOW}➤ Memeriksa ulang sertifikat setelah perpanjangan...${NC}"
certbot certificates

echo -e "${BLUE}➤ Mengatur ulang dan memulai ulang layanan Wings...${NC}"
systemctl reset-failed wings && systemctl restart wings

echo -e "${CYAN}===================================="
echo -e "✅ ${GREEN}Proses selesai! Semua layanan diperbarui.${NC}"
echo -e "🔗 ${YELLOW}Follow: https://linsofc.github.io${NC}"
echo -e "===================================="
