Подготовка репозитория для деплоя на Render

1) Что уже сделано
- Добавлен корневой `Dockerfile` (корректно собирает `backend`).
- Обновлён `render.yaml` на `dockerfilePath: Dockerfile`.
- Добавлен `.gitignore`.

2) Переменные окружения (установить в Render → Service → Environment)
- `DATABASE_URL` — Postgres/DB подключение
- `REDIS_URL` — redis (если используется)
- `JWT_SECRET` — секрет для подписывания JWT
- `NODE_ENV` — `production`
- `PORT` — `3000` (можно не задавать, Render задаёт свой, но в Dockerfile указан 3000)

3) GitHub Secrets (для автоматического триггера из workflow)
- `RENDER_API_KEY` — API key (Account → API Keys)
- `RENDER_SERVICE_ID` — ID сервиса (берётся из URL сервиса в Render)

4) Как создать сервис в Render
- Войдите в Render → New → Web Service → Connect GitHub → выберите ветку `main`.
- Выберите опцию `Use render.yaml` (рекомендовано) — Render автоматически применит `render.yaml`.
- Если создаёте вручную, выберите Docker и укажите `Dockerfile` (корень репозитория).
- После создания в разделе Environment добавьте перечисленные переменные и секреты.

5) Проверка и деплой
- Убедитесь, что `backend` корректно собирается локально: `cd backend && npm ci && npm run build`.
- В Render нажмите Deploy или выполните пуш — workflow `.github/workflows/deploy-render.yml` может триггерить деплой при наличии `RENDER_API_KEY` и `RENDER_SERVICE_ID`.

6) Полезные заметки
- Если сервис уже создавался с указанием `backend/Dockerfile`, проще удалить и создать заново с `render.yaml` или обновить настройку на `Dockerfile`.
- Не храните секреты в репозитории.

Если хотите, могу пока: добавить шаблон секрета `.env.render.example` (без значений) и закоммитить — скажите "да".
