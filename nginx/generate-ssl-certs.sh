#!/bin/bash

# ============================================
# Генерация самоподписанных SSL сертификатов
# ============================================
# 
# Использование:
#   ./generate-ssl-certs.sh [domain]
#   ./generate-ssl-certs.sh yourdomain.com
# 
# Для production используйте Let's Encrypt!
# ============================================

DOMAIN=${1:-localhost}
SSL_DIR="./ssl"
DAYS=365

echo "🔐 Генерация SSL сертификатов для $DOMAIN"
echo "============================================"
echo ""

# Создание директории
mkdir -p "$SSL_DIR"

# Генерация приватного ключа
echo "📝 Генерация приватного ключа..."
openssl genrsa -out "$SSL_DIR/privkey.pem" 2048

# Генерация CSR (Certificate Signing Request)
echo "📝 Генерация CSR..."
openssl req -new -key "$SSL_DIR/privkey.pem" -out "$SSL_DIR/cert.csr" \
    -subj "/C=RU/ST=Moscow/L=Moscow/O=Septik Service/OU=IT/CN=$DOMAIN"

# Генерация самоподписанного сертификата
echo "📝 Генерация сертификата..."
openssl x509 -req -days $DAYS \
    -in "$SSL_DIR/cert.csr" \
    -signkey "$SSL_DIR/privkey.pem" \
    -out "$SSL_DIR/fullchain.pem" \
    -extfile <(printf "subjectAltName=DNS:$DOMAIN,DNS:*.$DOMAIN,DNS:localhost")

# Копирование для chain
cp "$SSL_DIR/fullchain.pem" "$SSL_DIR/chain.pem"

# Установка прав
chmod 600 "$SSL_DIR/privkey.pem"
chmod 644 "$SSL_DIR/fullchain.pem"
chmod 644 "$SSL_DIR/chain.pem"

# Очистка
rm "$SSL_DIR/cert.csr"

echo ""
echo "✅ Сертификаты созданы успешно!"
echo ""
echo "📁 Файлы:"
echo "  - $SSL_DIR/privkey.pem (приватный ключ)"
echo "  - $SSL_DIR/fullchain.pem (сертификат)"
echo "  - $SSL_DIR/chain.pem (цепочка)"
echo ""
echo "⚠️  ВАЖНО:"
echo "  - Это самоподписанные сертификаты для разработки"
echo "  - Браузеры будут показывать предупреждение"
echo "  - Для production используйте Let's Encrypt"
echo ""
echo "🔒 Let's Encrypt (production):"
echo "  certbot certonly --webroot -w /var/www/certbot -d $DOMAIN"
echo ""
