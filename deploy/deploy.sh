#!/bin/bash

# =================================================================
# Skrip Konfigurasi Proyek Next.js (sbtopup) YANG SUDAH ADA
#
# Dijalankan di server VPS (diasumsikan Ubuntu/Debian).
# Mengasumsikan NVM, Node.js, PM2, Nginx, dan Certbot sudah terinstal.
# =================================================================

# Hentikan skrip jika ada perintah yang gagal
set -e

# --- Fungsi Bantuan untuk Output Berwarna ---
info() {
    echo -e "\n\e[34m\e[1mINFO:\e[0m $1\e[0m"
}

success() {
    echo -e "\n\e[32m\e[1mSUKSES:\e[0m $1\e[0m"
}

warn() {
    echo -e "\n\e[33m\e[1mPERINGATAN:\e[0m $1\e[0m"
}

error() {
    echo -e "\n\e[31m\e[1mERROR:\e[0m $1" >&2
    exit 1
}

# --- Variabel Tetap ---
BASE_DIR="/var/www"        # Direktori instalasi
APP_PORT="3000"            # Port internal aplikasi Anda

# =================================================================
# LANGKAH 0: Meminta Input dari User
# =================================================================
info "Memulai proses setup. Harap masukkan detail yang diperlukan."

read -p "1. Masukkan nama domain Anda (misal: sbprint.linsofc.my.id): " DOMAIN_NAME
read -p "2. Masukkan Nama Folder Proyek (yang ada di /var/www/): " PROJECT_DIR_NAME
read -p "3. Masukkan Nama Aplikasi PM2 (misal: sbtopup-prod): " PM2_APP_NAME

# Cek input
if [ -z "$DOMAIN_NAME" ] || [ -z "$PROJECT_DIR_NAME" ] || [ -z "$PM2_APP_NAME" ]; then
    error "Domain, Nama Folder, dan Nama PM2 tidak boleh kosong."
fi

# =================================================================
# LANGKAH 1: Peringatan DNS
# =================================================================
warn "PASTIKAN Anda telah mengarahkan A Record domain ${DOMAIN_NAME} ke IP server ini."
read -p "Tekan [ENTER] jika Anda sudah melakukannya..."

# =================================================================
# LANGKAH 2: Peringatan Prasyarat
# =================================================================
warn "Skrip ini mengasumsikan NVM, Node.js, PM2, Nginx, dan Certbot sudah terinstal."
warn "Pastikan juga folder '${BASE_DIR}/${PROJECT_DIR_NAME}' sudah ada."
read -p "Tekan [ENTER] untuk melanjutkan..."

# =================================================================
# LANGKAH 3: Build Project yang Sudah Ada
# =================================================================
PROJECT_PATH="${BASE_DIR}/${PROJECT_DIR_NAME}"

info "Pindah ke direktori proyek: ${PROJECT_PATH}..."
# Cek jika direktori ada
if [ ! -d "$PROJECT_PATH" ]; then
    error "Direktori ${PROJECT_PATH} tidak ditemukan."
fi
cd "$PROJECT_PATH"

warn "PASTIKAN file .env sudah ada dan terkonfigurasi di ${PROJECT_PATH}/.env"
read -p "Tekan [ENTER] jika file .env sudah siap..."

info "Mengaktifkan NVM (jika ada)..."
# Mencoba mengaktifkan NVM. Gagal tidak akan menghentikan skrip.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || warn "NVM tidak ditemukan, pastikan Node.js ada di PATH."

info "Menginstal dependensi NPM..."
npm install

info "Mem-build proyek (npm run build)..."
npm run build

# =================================================================
# Langkah 4: Jalankan Aplikasi dengan PM2
# =================================================================
info "Menjalankan aplikasi dengan PM2 (nama: ${PM2_APP_NAME})..."

# Hentikan/Hapus proses PM2 lama jika ada
pm2 delete "$PM2_APP_NAME" || true

# Mulai proses baru dari dalam folder proyek
pm2 start npm --name "$PM2_APP_NAME" -- run start

info "Menyimpan daftar proses PM2..."
pm2 save

info "Mengatur PM2 agar start-up saat boot..."
pm2 startup || warn "Tidak dapat mengatur pm2 startup secara otomatis."

# =================================================================
# LANGKAH 5: Konfigurasi Nginx (Reverse Proxy)
# =================================================================
info "Membuat file konfigurasi Nginx untuk ${DOMAIN_NAME}..."

NGINX_CONF_FILE="/etc/nginx/sites-available/$DOMAIN_NAME"

cat << EOF > $NGINX_CONF_FILE
server {
    listen 80;
    server_name $DOMAIN_NAME;

    location / {
        proxy_pass http://localhost:$APP_PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

info "Mengaktifkan konfigurasi Nginx..."
# Hapus symlink lama jika ada
rm -f /etc/nginx/sites-enabled/$DOMAIN_NAME
# Buat symlink baru
ln -s $NGINX_CONF_FILE /etc/nginx/sites-enabled/

info "Mengecek sintaks Nginx..."
nginx -t

info "Me-restart Nginx..."
systemctl restart nginx

# =================================================================
# LANGKAH 6: Instalasi SSL (Certbot)
# =================================================================
info "Membersihkan file lock Certbot (jika ada)..."
rm -f /var/lib/letsencrypt/.certbot.lock

info "Meminta sertifikat SSL untuk ${DOMAIN_NAME}..."
info "CATATAN: Silakan ikuti instruksi interaktif dari Certbot."
# Jalankan Certbot secara INTERAKTIF (karena kita tidak meminta email)
certbot --nginx -d "$DOMAIN_NAME"

success "========= KONFIGURASI SELESAI! =========="
echo "Proyek Anda (${PM2_APP_NAME}) sekarang berjalan."
echo "Domain: https://${DOMAIN_NAME}"
echo "Anda dapat memonitor log dengan: pm2 logs ${PM2_APP_NAME}"
echo "========================================"
