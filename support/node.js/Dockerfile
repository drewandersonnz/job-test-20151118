FROM node:5.0.0

COPY package.json /src/package.json

RUN cd /src; npm install

# Bundle app source
COPY . /src

# replace this with your application's default port
EXPOSE 8080
CMD ["node", "/src/index.js"]
