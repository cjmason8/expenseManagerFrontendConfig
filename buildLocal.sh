#!/bin/bash

FULL_IMAGE_NAME=expense-manager-frontend
TAG_NAME=$(<LOCAL)

echo "Beginning cleanup step."
echo "Removing docker images for: ${FULL_IMAGE_NAME}"
set +e
# Below to be implemented when docker has been updated to >1.10
#  docker rmi -f $(docker images --format "{{.Repository}}:{{.Tag}}" ${FULL_IMAGE_NAME}) 2> /dev/null
docker rmi $(docker images | grep "^${FULL_IMAGE_NAME}" | awk "{print $3}") 2> /dev/null

echo "Beginning preparation step."
if [ -z "${TAG_NAME}" ]; then
  echo "No tag name defined, unable to continue."
  exit 1
fi

TAG_NAME="${TAG_NAME%.*}.$((${TAG_NAME##*.}+1))"
echo $TAG_NAME > LOCAL

echo "Creating image: ${FULL_IMAGE_NAME}:${TAG_NAME}"

#echo "maven"
cd ../expenseManagerFrontend

docker build -f ../expenseManagerFrontendConfig/Dockerfile_lcl --no-cache --pull --build-arg env=${ENV_NAME} -t ${FULL_IMAGE_NAME}:${TAG_NAME} .

docker tag ${FULL_IMAGE_NAME}:${TAG_NAME} cjmason8/${FULL_IMAGE_NAME}:${TAG_NAME}
docker tag ${FULL_IMAGE_NAME}:${TAG_NAME} cjmason8/${FULL_IMAGE_NAME}:latest
#docker push cjmason8/${FULL_IMAGE_NAME}:latest
#docker push cjmason8/${FULL_IMAGE_NAME}:${TAG_NAME}