<<<<<<< Updated upstream
FROM node:11.12.0-alpine
=======
FROM node:11.12-alpine
>>>>>>> Stashed changes

MAINTAINER "Chris Mason <cjmason8@gmail.com>"

ARG env

RUN apk update
RUN apk add curl

# App Config
COPY src /app/src
COPY angular.json /app/
COPY package.json /app/

WORKDIR /app

RUN npm install
RUN npm install -g @angular/cli

RUN ng build

EXPOSE 4200
