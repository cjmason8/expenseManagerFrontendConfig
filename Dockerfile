FROM cjmason8/ubuntu-nodev6:latest

MAINTAINER "Chris Mason <cjmason8@gmail.com>"

ARG env

# App Config
COPY src /app/src
COPY angular-cli.json /app/
COPY package.json /app/

WORKDIR /app

RUN npm install
RUN npm install -g @angular/cli

RUN ng build

EXPOSE 4200
