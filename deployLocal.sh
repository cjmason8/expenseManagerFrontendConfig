#!/bin/bash

TAG_NAME=$(<LOCAL)
COMPUTER_NAME=$(cat /proc/sys/kernel/hostname)

if [ $COMPUTER_NAME = "maso34" ]; then
    ./deploy.sh EBFC0D6EB6ED7C6334D2 RpJgjrsVdCmTFEmqbP1NPFdUhCWAckbff2p3zsJX http://localhost:8080/v2-beta/projects/1a5 lcl $TAG_NAME
else
    ./deploy.sh C3EB1019A856653D3D7A WcF7KbNgrUStCYryH7YWKPvKf3VkfV3rnvtb4QnF http://localhost:8080/v2-beta/projects/1a5 lcl
fi
