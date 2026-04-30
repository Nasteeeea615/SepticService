# ============================================
# Генерация самоподписанных SSL сертификатов (Windows)
# ============================================
# 
# Использование:
#   .\generate-ssl-certs.ps1 [domain]
#   .\generate-ssl-certs.ps1 yourdomain.com
# 
# Для production используйте Let's Encrypt!
# ============================================

param(
    [string]$Domain = "localhost"
)

$sslDir = ".\ssl"
$days = 365

Write-Host "🔐 Генерация SSL сертификатов для $Domain" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Создание директории
if (-not (Test-Path $sslDir)) {
    New-Item -ItemType Directory -Path $sslDir | Out-Null
}

# Проверка наличия OpenSSL
if (-not (Get-Command openssl -ErrorAction SilentlyContinue)) {
    Write-Host "❌ OpenSSL не найден" -ForegroundColor Red
    Write-Host ""
    Write-Host "Установите OpenSSL:" -ForegroundColor Yellow
    Write-Host "  1. Скачайте: https://slproweb.com/products/Win32OpenSSL.html" -ForegroundColor Yellow
    Write-Host "  2. Или используйте: winget install OpenSSL.Light" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host "✅ OpenSSL найден" -ForegroundColor Green

# Генерация приватного ключа
Write-Host "📝 Генерация приватного ключа..." -ForegroundColor Blue
openssl genrsa -out "$sslDir\privkey.pem" 2048 2>$null

# Генерация CSR
Write-Host "📝 Генерация CSR..." -ForegroundColor Blue
$subject = "/C=RU/ST=Moscow/L=Moscow/O=Septik Service/OU=IT/CN=$Domain"
openssl req -new -key "$sslDir\privkey.pem" -out "$sslDir\cert.csr" -subj $subject 2>$null

# Создание конфигурации для SAN
$sanConfig = @"
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
C = RU
ST = Moscow
L = Moscow
O = Septik Service
OU = IT
CN = $Domain

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = $Domain
DNS.2 = *.$Domain
DNS.3 = localhost
"@

$sanConfig | Out-File -FilePath "$sslDir\san.cnf" -Encoding ASCII

# Генерация самоподписанного сертификата
Write-Host "📝 Генерация сертификата..." -ForegroundColor Blue
openssl x509 -req -days $days `
    -in "$sslDir\cert.csr" `
    -signkey "$sslDir\privkey.pem" `
    -out "$sslDir\fullchain.pem" `
    -extfile "$sslDir\san.cnf" `
    -extensions v3_req 2>$null

# Копирование для chain
Copy-Item "$sslDir\fullchain.pem" "$sslDir\chain.pem"

# Очистка
Remove-Item "$sslDir\cert.csr" -ErrorAction SilentlyContinue
Remove-Item "$sslDir\san.cnf" -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "✅ Сертификаты созданы успешно!" -ForegroundColor Green
Write-Host ""
Write-Host "📁 Файлы:" -ForegroundColor Cyan
Write-Host "  - $sslDir\privkey.pem (приватный ключ)"
Write-Host "  - $sslDir\fullchain.pem (сертификат)"
Write-Host "  - $sslDir\chain.pem (цепочка)"
Write-Host ""
Write-Host "⚠️  ВАЖНО:" -ForegroundColor Yellow
Write-Host "  - Это самоподписанные сертификаты для разработки"
Write-Host "  - Браузеры будут показывать предупреждение"
Write-Host "  - Для production используйте Let's Encrypt"
Write-Host ""
Write-Host "🔒 Let's Encrypt (production):" -ForegroundColor Cyan
Write-Host "  certbot certonly --webroot -w /var/www/certbot -d $Domain"
Write-Host ""

# Проверка сертификата
Write-Host "📋 Информация о сертификате:" -ForegroundColor Cyan
openssl x509 -in "$sslDir\fullchain.pem" -noout -subject -dates -ext subjectAltName
Write-Host ""
