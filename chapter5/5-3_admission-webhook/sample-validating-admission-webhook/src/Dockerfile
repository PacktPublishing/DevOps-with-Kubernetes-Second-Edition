FROM node:9.11

WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .

EXPOSE 443
CMD [ "node", "app.js" ]
