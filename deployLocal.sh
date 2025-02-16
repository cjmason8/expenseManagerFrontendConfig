#!/bin/bash

export TAG_NAME=$(<LOCAL)

docker-compose -f lcl/docker-compose-lcl.yml up
