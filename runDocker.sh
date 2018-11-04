#!/bin/bash

set -e

ENV=$1
FULL_IMAGE_NAME="expense-manager-frontend"

if [ -z $ENV ]; then
  ENV=lcl
fi

echo "Building version."
TAG_NAME=0.0.1
echo -e "TAG_NAME=$TAG_NAME" > .env

echo "Creating image: ${FULL_IMAGE_NAME}:${TAG_NAME}"
cd ../expenseManagerFrontend

#cd ../expenseManagerFrontendConfig
#docker build -f Dockerfile_lcl --no-cache --pull -t ${FULL_IMAGE_NAME}:${TAG_NAME} .
docker build -f ../expenseManagerFrontendConfig/Dockerfile_lcl --no-cache --pull --build-arg env=${ENV_NAME} -t ${FULL_IMAGE_NAME}:${TAG_NAME} .
docker tag ${FULL_IMAGE_NAME}:${TAG_NAME} cjmason8/${FULL_IMAGE_NAME}:${TAG_NAME}
docker tag ${FULL_IMAGE_NAME}:${TAG_NAME} cjmason8/${FULL_IMAGE_NAME}:latest

cd ../expenseManagerFrontendConfig

docker-compose -f ${ENV}/docker-compose-${ENV}.yml up -d expenseManagerFrontend
