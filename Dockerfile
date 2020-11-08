FROM node:12

WORKDIR /usr/share/app

COPY package*.json ./
    
RUN npm install 

COPY . . 

EXPOSE 8080 

CMD ["node", "server.js"]