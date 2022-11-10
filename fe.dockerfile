FROM node:16-alpine AS builder

RUN apk add --no-cache libc6-compat

WORKDIR /app-fe

COPY package.json package-lock.json ./

RUN npm ci

FROM node:16-alpine

WORKDIR /app-fe

COPY --from=builder /app-fe/node_modules ./node_modules
COPY --from=builder /app-fe/package.json ./package.json

COPY . .

RUN chown -R node:node .

USER node

EXPOSE 3000

CMD ["npm", "start"]