# Self-contained backend image for Render.
# The repo root is a wrapper, so we clone the backend repository during build.

FROM node:18-alpine AS builder

RUN apk add --no-cache git

ARG BACKEND_REPO=https://github.com/Nasteeeea615/backend.git
ARG BACKEND_REF=main

WORKDIR /app

RUN git clone --depth 1 --branch ${BACKEND_REF} ${BACKEND_REPO} backend

WORKDIR /app/backend

RUN npm ci && \
  npm cache clean --force

RUN npm run build

FROM node:18-alpine

RUN apk add --no-cache dumb-init

RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app/backend

COPY --from=builder /app/backend/package*.json ./

RUN npm ci --only=production && npm cache clean --force

COPY --from=builder --chown=nodejs:nodejs /app/backend/dist ./dist

USER nodejs

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

ENTRYPOINT ["dumb-init", "--"]
CMD ["node", "dist/index.js"]