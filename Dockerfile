FROM node:18-alpine3.21 as builder

MAINTAINER "Chris Mason <cjmason8@gmail.com>"

ARG env

# App Config
COPY src /app/src
COPY angular.json /app/
COPY package.json /app/

WORKDIR /app

RUN npm install
RUN npm install -g @angular/cli
RUN npm install -g openssl

RUN ng build --configuration=production

FROM nginx:1.14.1-alpine

RUN apk update
RUN apk add curl

## Copy our default nginx config
COPY default.conf /etc/nginx/conf.d/
COPY openssl.cnf /etc/ssl/

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

## From ‘builder’ stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=builder /app/dist /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
