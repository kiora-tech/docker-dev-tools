#!/bin/bash

if [[ ! -z "$GIT_NAME" ]]
then
    git config --global user.name "$GIT_NAME"
    echo "Git config: $GIT_NAME"
fi

if [[ ! -z "$GIT_EMAIL" ]]
then
    git config --global user.email "$GIT_EMAIL"
    echo "Git config: $GIT_EMAIL"
fi


while true; do sleep 2; done