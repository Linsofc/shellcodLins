#!/bin/bash

# =================================================================
# Skrip Otomatisasi Deploy Proyek Next.js (sbtopup)
#
# Dijalankan di server VPS (diasumsikan Ubuntu/Debian).
# Jalankan sebagai user root atau user dengan hak sudo penuh.
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

# --- Variabel Tetap (Ubah di sini jika perlu) ---
REPO_URL="https://github.com/Linsofc/sbtopup.git"
PROJECT_DIR_NAME="sbtopup" # Nama folder kloning
PM2_APP_NAME="sbtopup"     # Nama aplikasi di PM2
BASE_DIR="/var/www"        # Direktori instalasi
APP_PORT="3000"            # Port internal aplikasi Anda

# =================================================================
# LANGKAH 0: Meminta Input dari User
# =================================================================
info "Memulai proses setup. Harap masukkan detail yang diperlukan."

read -p "1. Masukkan nama domain Anda (misal: sbprint.linsofc.my.id): " DOMAIN_NAME
read -p "2. Masukkan email Anda (untuk notifikasi SSL/Certbot): " EMAIL_FOR_SSL
read -p "3. Masukkan DIGI_USER: " DIGI_USER
read -p "4. Masukkan DIGI_API: " DIGI_API
read -p "5. Masukkan NEXT_PUBLIC_APP_USERNAME: " NEXT_PUBLIC_APP_USERNAME
read -s -p "6. Masukkan NEXT_PUBLIC_APP_PASSWORD: " NEXT_PUBLIC_APP_PASSWORD
echo
read -s -p "7. Masukkan NEXT_PUBLIC_TRANSACTION_PASSWORD: " NEXT_PUBLIC_TRANSACTION_PASSWORD
echo

# Cek input
if [ -z "$DOMAIN_NAME" ] || [ -z "$EMAIL_FOR_SSL" ] || [ -z "$DIGI_USER" ]; then
    error "Domain, Email, dan DIGI_USER tidak boleh kosong."
fi

# =================================================================
# LANGKAH 1: Peringatan DNS
# =================================================================
warn "PASTIKAN Anda telah mengarahkan A Record domain ${DOMAIN_NAME} ke IP server ini."
read -p "Tekan [ENTER] jika Anda sudah melakukannya..."

# =================================================================
# LANGKAH 2: Persiapan Server (NVM, Node.js, PM2)
# =================================================================
info "Memperbarui paket dan menginstal dependensi (curl, git, nginx, snapd)..."
apt-get update
apt-get install -y curl git nginx snapd

info "Menginstal NVM (Node Version Manager)..."
# Diasumsikan skrip dijalankan sebagai root, NVM akan terinstal di /root/.nvm
export NVM_DIR="$HOME/.nvm"
if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# Mengaktifkan NVM untuk sesi skrip ini
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

info "Menginstal Node.js versi LTS..."
nvm install --lts
nvm use --lts

info "Menginstal PM2 secara global..."
npm install -g pm2

# =================================================================
# LANGKAH 3: Dapatkan Kode dan Build Project
# =================================================================
info "Membuat direktori ${BASE_DIR}..."
mkdir -p "$BASE_DIR"
cd "$BASE_DIR"

info "Menghapus folder proyek lama jika ada..."
rm -rf "$PROJECT_DIR_NAME"

info "Melakukan 'git clone' dari ${REPO_URL}..."
git clone "$REPO_URL" "$PROJECT_DIR_NAME"
cd "$PROJECT_DIR_NAME"

info "Membuat file .env..."
cat << EOF > .env
DIGI_USER=${DIGI_USER}
DIGI_API=${DIGI_API}

# App Authentication
NEXT_PUBLIC_APP_USERNAME=${NEXT_PUBLIC_APP_USERNAME}
NEXT_PUBLIC_APP_PASSWORD=${NEXT_PUBLIC_APP_PASSWORD}

# Transaction Password
NEXT_PUBLIC_TRANSACTION_PASSWORD=${NEXT_PUBLIC_TRANSACTION_PASSWORD}
EOF

info "Menginstal dependensi NPM..."
npm install

info "Mem-build proyek (npm run build)..."
npm run build

# =Langkah 4: Jalankan Aplikasi dengan PM2
# =================================================================
info "Menjalankan aplikasi dengan PM2 (nama: ${PM2_APP_NAME})..."

# Hentikan/Hapus proses PM2 lama jika ada
pm2 delete "$PM2_APP_NAME" || true

# Mulai proses baru
pm2 start npm --name "$PM2_APP_NAME" -- run start

info "Menyimpan daftar proses PM2..."
pm2 save

info "Mengatur PM2 agar start-up saat boot..."
# Ini mungkin menampilkan perintah untuk dijalankan, tetapi seharusnya bekerja otomatis sebagai root
pm2 startup || warn "Tidak dapat mengatur pm2 startup secara otomatis."

# =================================================================
# LANGKAH 5: Konfigurasi Nginx (Reverse Proxy)
# =================================================================
info "Membuat file konfigurasi Nginx untuk ${DOMAIN_NAME}..."

cat << EOF > /etc/nginx/sites-available/$DOMAIN_NAME
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
ln -s /etc/nginx/sites-available/$DOMAIN_NAME /etc/nginx/sites-enabled/

info "Mengecek sintaks Nginx..."
nginx -t

info "Me-restart Nginx..."
systemctl restart nginx

# =================================================================
# LANGKAH 6: Instalasi SSL (Certbot)
# =================================================================
info "Menginstal Certbot..."
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot || true

info "Membersihkan file lock Certbot (jika ada)..."
rm -f /var/lib/letsencrypt/.certbot.lock

info "Meminta sertifikat SSL untuk ${DOMAIN_NAME}..."
# Jalankan Certbot secara non-interaktif
certbot --nginx --non-interactive --agree-tos -m "$EMAIL_FOR_SSL" -d "$DOMAIN_NAME"

success "========= DEPLOY SELESAI! =========="
echo "Proyek Anda (${PM2_APP_NAME}) sekarang berjalan."
echo "Domain: https://${DOMAIN_NAME}"
echo "Anda dapat memonitor log dengan: pm2 logs ${PM2_APP_NAME}"
echo "========================================"
