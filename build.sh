#!/bin/bash

set -e

ENV=$1
GIT_PASS=$2

if [ -z $ENV ]; then
  ENV=lcl
fi

FULL_IMAGE_NAME="expense-manager-frontend"

git checkout master
git pull origin master

if [ $ENV != "lcl" ]; then
  echo "Building version."
  TAG_NAME=$(<VERSION)
  TAG_NAME="${TAG_NAME%.*}.$((${TAG_NAME##*.}+1))"
  echo $TAG_NAME > VERSION

  echo "commiting bump version"
  git config user.name "Release Manager"
  git config user.email "Release.Manager@jenkins.com.au"
  git add --all
  git commit -m "bump version"
  git push https://cjmason8:${GIT_PASS}@github.com/cjmason8/expenseManagerFrontendConfig.git
else
  echo "Building version."
  TAG_NAME=$(<LOCAL)
  TAG_NAME="${TAG_NAME%.*}.$((${TAG_NAME##*.}+1))"
  echo $TAG_NAME > LOCAL
fi

echo "Beginning cleanup step."
echo "Removing docker images for: ${FULL_IMAGE_NAME}"
set +e
# Below to be implemented when docker has been updated to >1.10
#  docker rmi -f $(docker images --format "{{.Repository}}:{{.Tag}}" ${FULL_IMAGE_NAME}) 2> /dev/null
docker rmi $(docker images | grep "^${FULL_IMAGE_NAME}" | awk "{print $3}") 2> /dev/null
set -e

echo "Beginning preparation step."
if [ -z "${TAG_NAME}" ]; then
  echo "No tag name defined, unable to continue."
  exit 1
fi
if [[ "$(docker images -q ${FULL_IMAGE_NAME}:${TAG_NAME} 2> /dev/null)" == "" ]]; then

cd expenseManagerFrontend
git pull https://cjmason8:${GIT_PASS}@github.com/cjmason8/expenseManagerFrontend.git
echo "Creating image: ${FULL_IMAGE_NAME}:${TAG_NAME}"
  if [ $ENV == "lcl" ]; then
    docker build -f ../Dockerfile_lcl --no-cache --pull --build-arg env=${ENV_NAME} -t ${FULL_IMAGE_NAME}:${TAG_NAME} .
  else
    cp ../Dockerfile .
    docker build --no-cache --pull --build-arg env=${ENV_NAME} -t ${FULL_IMAGE_NAME}:${TAG_NAME} .
  fi
fi

echo "Beginning publish step."
echo "Pushing image to repository: ${FULL_IMAGE_NAME}:${TAG_NAME}"
docker tag ${FULL_IMAGE_NAME}:${TAG_NAME} cjmason8/${FULL_IMAGE_NAME}:${TAG_NAME}
docker tag ${FULL_IMAGE_NAME}:${TAG_NAME} cjmason8/${FULL_IMAGE_NAME}:latest
docker push cjmason8/${FULL_IMAGE_NAME}:latest
docker push cjmason8/${FULL_IMAGE_NAME}:${TAG_NAME}
