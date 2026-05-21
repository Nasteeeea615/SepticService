# Инструкции по тестированию SepticService

Полный набор тестов для проверки работоспособности всех сервисов без использования UI.

## 🚀 Быстрый старт (удаленное тестирование)

Если вы находитесь удаленно от компа, используйте **curl** команды ниже для тестирования каждого сервиса.

---

## 📋 Вариант 1: Npm скрипты (локально)

### Требования:
- Node.js 16+ установлен
- npm зависимости установлены (`npm install`)

### Комманды:

#### Тестировать Production (Render)
```bash
cd backend
npm run test:full:prod
```

#### Тестировать Staging (если существует)
```bash
cd backend
npm run test:full:staging
```

#### Тестировать локально (если backend запущен на localhost:3000)
```bash
cd backend
npm install  # убедитесь в зависимостях
npm run test:full:local
```

#### Тестировать произвольный URL
```bash
cd backend
STAGING_URL=https://your-custom-url.com npm run test:full
```

---

## 🔗 Вариант 2: Curl команды (удаленное тестирование)

Используйте эти команды в терминале для проверки отдельных компонентов.

### 1. **Health Check** (базовая проверка всех сервисов)
```bash
curl -i https://septicservice.onrender.com/health
```

Ожидаемый ответ:
```json
{
  "status": "ok",
  "database": "connected",
  "redis": "connected",
  "socketio": "ready"
}
```

---

### 2. **Проверка базы данных**
```bash
curl -i https://septicservice.onrender.com/api/health/db
```

Ожидаемый ответ: `{"connected": true}`

---

### 3. **Проверка Redis**
```bash
curl -i https://septicservice.onrender.com/api/health/redis
```

Ожидаемый ответ: `{"connected": true}`

---

### 4. **Регистрация клиента**
```bash
curl -X POST https://septicservice.onrender.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test-client-'$(date +%s)'@example.com",
    "password": "TestPassword123!",
    "phone": "+79991234567",
    "role": "client"
  }'
```

Сохраните `token` из ответа для использования в следующих тестах.

---

### 5. **Вход в систему (Login)**
```bash
curl -X POST https://septicservice.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test-client-1234567890@example.com",
    "password": "TestPassword123!"
  }'
```

---

### 6. **Создание заказа** (требуется AUTH_TOKEN)
```bash
curl -X POST https://septicservice.onrender.com/api/orders \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN" \
  -d '{
    "title": "Test Order",
    "description": "Cleaning septic tank",
    "address": "Test Address, City",
    "serviceType": "cleaning",
    "estimatedBudget": 5000
  }'
```

Замените `YOUR_AUTH_TOKEN` на токен из регистрации.

---

### 7. **Получить список заказов** (требуется AUTH_TOKEN)
```bash
curl -i https://septicservice.onrender.com/api/orders \
  -H "Authorization: Bearer YOUR_AUTH_TOKEN"
```

---

### 8. **Проверка Rate Limiting**
```bash
# Отправьте несколько быстрых запросов
for i in {1..10}; do
  curl -s -o /dev/null -w "Request $i: %{http_code}\n" https://septicservice.onrender.com/health
done
```

Должны увидеть `429 Too Many Requests` после превышения лимита.

---

### 9. **Тест WebSocket** (real-time notifications)

Используйте `wscat` утилиту:

```bash
# Установите если нет
npm install -g wscat

# Подключитесь к WebSocket
wscat -c wss://septicservice.onrender.com/socket.io/?transport=websocket

# После подключения, отправьте сообщение в формате Socket.io
> {"type":"message"}
```

---

### 10. **Проверка Платежей (Webhook тест)**

```bash
# Создайте подпись
export SECRET="your-yookassa-secret"
export BODY='{"event":"payment.succeeded","object":{"id":"test-123","status":"succeeded","amount":{"value":"100.00","currency":"RUB"}}}'
export SIGNATURE=$(echo -n "$BODY" | openssl dgst -sha256 -hmac "$SECRET" -hex | cut -d' ' -f2)

curl -X POST https://septicservice.onrender.com/api/webhooks/yookassa \
  -H "Content-Type: application/json" \
  -H "X-Request-Signature: $SIGNATURE" \
  -d "$BODY"
```

---

## ✅ Checklist проверки

Используйте этот список для повседневной валидации:

- [ ] `/health` возвращает `status: ok` с `database: connected` и `redis: connected`
- [ ] Регистрация новых пользователей работает
- [ ] Логин возвращает валидный JWT token
- [ ] Создание заказов работает для аутентифицированных пользователей
- [ ] Rate limiting активен (429 после превышения лимита)
- [ ] WebSocket соединение устанавливается
- [ ] Payment webhooks обрабатываются корректно
- [ ] Admin dashboard загружается без ошибок
- [ ] Mobile app коннектится к API (проверить логи в Expo)

---

## 🔍 Расширенная диагностика

### Просмотр логов Render
```bash
# Используйте Render Dashboard или:
# https://dashboard.render.com/services/your-service-id
```

### Проверка переменных окружения
```bash
curl -i https://septicservice.onrender.com/api/config/env
# (если endpoint существует)
```

### Проверка PostgreSQL соединения
```bash
# В Render Dashboard:
# Services > Your Service > Logs
# Ищите сообщения о "connected" или "timeout"
```

### Проверка Redis соединения
```bash
# В RedisLabs/Render Dashboard:
# Проверьте активные соединения и используемую память
```

---

## 🐛 Типичные проблемы и решения

### ❌ "Connection timeout" на БД
**Решение:**
- Проверьте `DATABASE_URL` в Render environment variables
- Убедитесь что SSL включен: `?sslmode=require`
- Увеличьте `connectionTimeoutMillis` в backend/src/config/database.ts

### ❌ "Redis connection failed"
**Решение:**
- Проверьте `REDIS_URL` в Render environment variables
- Убедитесь что RedisLabs доступна из Render
- Проверьте firewall rules в RedisLabs dashboard

### ❌ "Rate limit not working"
**Решение:**
- Убедитесь что Redis работает (rate-limiter используется Redis для состояния)
- Проверьте `RATE_LIMIT_STORE=redis` в env vars
- Перезагрузите backend service

### ❌ "CORS errors на mobile/admin"
**Решение:**
- Проверьте `VITE_API_URL` в admin/.env.production
- Проверьте `EXPO_PUBLIC_API_URL` в mobile/.env
- Убедитесь что backend CORS headers установлены

---

## 📊 Интерпретация результатов тестов

```
✅ PASS - Тест пройден успешно
❌ FAIL - Критический тест провален, требует исправления
⏭️  SKIP - Опциональный тест пропущен (информативно)
```

### Статусы тестов:
- **All tests passed** → Application ready ✅
- **Some tests failed** → Critical issues detected ❌
- **Some tests skipped** → Optional services unavailable ⚠️

---

## 🚀 Continuous Testing

Для автоматизированного тестирования, добавьте в GitHub Actions:

```yaml
# .github/workflows/e2e-test.yml
name: E2E Tests on Render
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
      - run: cd backend && npm install
      - run: npm run test:full:prod
```

---

## 📞 Поддержка

Если тесты падают, соберите информацию:
1. Полный вывод теста (скопируйте в файл)
2. Логи Render Backend service
3. Переменные окружения (без secrets)
4. Версии Node/npm (`node -v`, `npm -v`)

Отправьте в issues репозитория.
