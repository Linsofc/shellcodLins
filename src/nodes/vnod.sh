#!/bin/bash

# Warna untuk output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Reset warna

echo -e "${GREEN}Memeriksa sertifikat yang ada...${NC}"
certbot certificates

echo -e "${RED}Menghentikan layanan Nginx...${NC}"
systemctl stop nginx

echo -e "${GREEN}Memperbarui sertifikat SSL...${NC}"
certbot renew

echo -e "${RED}Memulai ulang layanan Nginx...${NC}"
systemctl restart nginx

echo -e "${GREEN}Memeriksa ulang sertifikat setelah perpanjangan...${NC}"
certbot certificates

echo -e "${RED}Mengatur ulang dan memulai ulang layanan Wings...${NC}"
systemctl reset-failed wings && systemctl restart wings

echo -e "${GREEN}Selesai! Semua layanan telah diperbarui dan dijalankan.${NC}"
