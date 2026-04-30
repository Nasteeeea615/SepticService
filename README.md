# Septik Service App

Мобильное приложение для заказа услуг по откачке септика. Работает по принципу Яндекс.Такси: клиенты создают заказы, исполнители принимают их и выполняют, оплата происходит через приложение.

## 🏗️ Архитектура

- **Backend**: Node.js + Express + TypeScript + PostgreSQL + Redis
- **Mobile**: React Native + Expo + TypeScript
- **Admin Panel**: React + TypeScript + Material-UI

## 🚀 Быстрый старт

### Требования

- Node.js 18+
- Docker и Docker Compose
- PostgreSQL 15+
- Redis
- Expo CLI (для mobile)

### Установка

```bash
# Клонировать репозиторий
git clone <repository-url>
cd septik-service-app

# Установить зависимости для всех проектов
npm run install:all
```

### Запуск с Docker

```bash
# Запустить все сервисы
docker-compose up -d

# Применить миграции
docker-compose exec backend npm run migrate

# Просмотр логов
docker-compose logs -f
```

### Запуск без Docker

**Backend:**
```bash
cd backend
# создайте файл .env и заполните переменные окружения
npm install
npm run migrate
npm run dev
```

**Mobile:**
```bash
cd mobile
# создайте файл .env и заполните переменные окружения
npm install
npm start
```

**Admin:**
```bash
cd admin
# создайте файл .env и заполните переменные окружения
npm install
npm start
```

## 📱 Функциональность

### Для клиентов
- ✅ Регистрация через SMS
- ✅ Создание заказов на откачку септика
- ✅ Выбор объема машины (3, 5, 10 м³)
- ✅ Просмотр истории заказов
- ✅ Оплата через приложение
- ✅ Push-уведомления
- ✅ Служба поддержки
- ✅ Светлая/темная тема

### Для исполнителей
- ✅ Регистрация с указанием машины
- ✅ Просмотр доступных заказов
- ✅ Принятие заказов
- ✅ Завершение заказов
- ✅ История выполненных заказов
- ✅ Push-уведомления

### Админ-панель
- ✅ Управление заказами
- ✅ Управление пользователями
- ✅ Управление платежами
- ✅ Система тикетов
- ✅ Аналитика и статистика

## 🛠️ Технологии

### Backend
- Express.js - веб-фреймворк
- PostgreSQL - основная БД
- Redis - кэширование
- Socket.io - WebSocket
- JWT - аутентификация
- Winston - логирование
- Joi - валидация
- Helmet - безопасность

### Mobile
- React Native + Expo
- Redux Toolkit - state management
- React Navigation - навигация
- React Native Paper - UI компоненты
- React Hook Form + Yup - валидация форм
- Axios - HTTP клиент
- Expo Notifications - push-уведомления
- Expo Secure Store - безопасное хранилище
- EAS Build - нативные сборки для iOS и Android
- Firebase Cloud Messaging - push-уведомления

### Admin Panel
- React + TypeScript
- Material-UI - UI компоненты
- React Router - роутинг
- Recharts - графики
- Axios - HTTP клиент

## 📚 Документация

- [START_HERE.md](./START_HERE.md) - быстрый старт по текущей структуре
- [backend/README.md](./backend/README.md) - backend API и запуск
- [mobile/README.md](./mobile/README.md) - mobile приложение
- [admin/README.md](./admin/README.md) - админ-панель

## 🔐 Безопасность

- ✅ HTTPS для всех запросов
- ✅ JWT токены с refresh
- ✅ Rate limiting
- ✅ Input sanitization
- ✅ SQL injection protection
- ✅ XSS protection
- ✅ CORS настройка
- ✅ Helmet.js security headers
- ✅ Secure storage для токенов

### Управление секретами (рекомендация)

Для production рекомендуется не хранить важные секреты в `.env` файлах или в репозитории. Используйте менеджеры секретов (например, HashiCorp Vault, AWS Secrets Manager, Google Secret Manager или GitHub Secrets) и подключайте их в CI/CD и на серверах во время деплоя.

Пример: в GitHub Actions добавьте `JWT_SECRET`, `YOOKASSA_SECRET_KEY` и другие ключи в `Secrets` и не коммитите их в репозиторий.

## ⚡ Производительность

- ✅ Redis кэширование
- ✅ Connection pooling
- ✅ Pagination
- ✅ Lazy loading
- ✅ Image optimization
- ✅ Debouncing
- ✅ SQL query optimization

## 🧪 Тестирование

```bash
# Backend тесты
cd backend
npm test

# Mobile тесты
cd mobile
npm test

# Admin тесты
cd admin
npm test
```

## 📦 Deployment

### Production

```bash
# Build Docker images
docker-compose -f docker-compose.prod.yml build

# Deploy
docker-compose -f docker-compose.prod.yml up -d

# Migrations
docker-compose -f docker-compose.prod.yml exec backend npm run migrate
```

### Mobile App

```bash
cd mobile

# Android
eas build --platform android --profile production

# iOS
eas build --platform ios --profile production

# Submit to stores
eas submit --platform android
eas submit --platform ios
```

## 🔧 Переменные окружения

### Backend (.env)
```env
NODE_ENV=development
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=septik_service
DB_USER=postgres
DB_PASSWORD=your_password
REDIS_HOST=localhost
REDIS_PORT=6379
JWT_SECRET=your_secret
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=your_smtp_user
SMTP_PASS=your_smtp_password
SMTP_FROM_EMAIL=no-reply@example.com
LOGIN_CODE_TTL_MINUTES=10
```

### Mobile (.env)
```env
API_URL=http://localhost:3000/api
```

### Admin (.env)
```env
REACT_APP_API_URL=http://localhost:3000/api
```

## 📊 Структура проекта

```
septik-service-app/
├── backend/              # Backend API
│   ├── src/
│   │   ├── controllers/  # Контроллеры
│   │   ├── services/     # Бизнес-логика
│   │   ├── routes/       # Маршруты
│   │   ├── middleware/   # Middleware
│   │   ├── utils/        # Утилиты
│   │   ├── types/        # TypeScript типы
│   │   ├── validation/   # Схемы валидации
│   │   └── database/     # Миграции и seeds
│   └── Dockerfile
├── mobile/               # Mobile приложение
│   ├── src/
│   │   ├── components/   # Компоненты
│   │   ├── screens/      # Экраны
│   │   ├── services/     # API сервисы
│   │   ├── store/        # Redux store
│   │   ├── navigation/   # Навигация
│   │   ├── theme/        # Тема
│   │   ├── hooks/        # Custom hooks
│   │   └── utils/        # Утилиты
│   └── eas.json
├── admin/                # Админ-панель
│   ├── src/
│   │   ├── components/   # Компоненты
│   │   ├── pages/        # Страницы
│   │   └── services/     # API сервисы
│   └── Dockerfile
├── nginx/                # Nginx конфигурация
├── .github/workflows/    # CI/CD
├── docker-compose.yml    # Docker Compose
└── README.md
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📝 License

MIT

## 👥 Team

- Backend Developer
- Mobile Developer
- Frontend Developer
- DevOps Engineer

## 📞 Support

Для вопросов и поддержки: support@example.com

## 🎯 Roadmap

### Завершено ✅
- [x] MVP функционал
- [x] Push-уведомления
- [x] Система поддержки
- [x] Админ-панель
- [x] CI/CD
- [x] Централизованное управление секретами
- [x] Staging окружение и E2E тестирование
- [x] Runtime Hardening (TLS, CORS, Rate Limiting, Security Headers)
- [x] Управление зависимостями и Dependabot
- [x] Native Mobile (EAS Build, Push-уведомления, App Store/Play Store)

### В планах 🚀
- [ ] Рейтинг исполнителей
- [ ] Чаевые
- [ ] Промокоды
- [ ] Реферальная программа
- [ ] Аналитика и мониторинг (Sentry, Firebase Analytics)
- [ ] A/B тестирование

## ⭐ Особенности

- **Современный стек** - последние версии технологий
- **TypeScript** - типобезопасность
- **Безопасность** - enterprise-level security
- **Производительность** - оптимизация на всех уровнях
- **Масштабируемость** - готовность к росту
- **Документация** - полная документация
- **CI/CD** - автоматизация deployment
- **Мониторинг** - логирование и метрики

---

Made with ❤️ by Septik Service Team
