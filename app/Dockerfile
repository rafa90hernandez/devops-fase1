# Build uma imagem mínima para o Node app
FROM node:18-alpine

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci --omit=dev

COPY src ./src
COPY .eslintrc.json ./
COPY jest.config.js ./

ENV PORT=3000
EXPOSE 3000

CMD [ "node", "src/index.js" ]
