#!/usr/bin/env bash

TAG=$1

if [ -z "$TAG" ]; then
    TAG="latest"
fi

CONTAINER=$( docker run -d -e APACHE_UID=$UID \
    -p 8051:8051 \
    -p 8052:8052 \
    -p 8053:8053 \
    -p 8054:8054 \
    -p 8055:8055 \
    -p 8056:8056 \
    -p 8070:8070 \
    -p 8071:8071 \
    -p 8072:8072 \
    eugenesia/phpfarm:$TAG )

if [ -z "$CONTAINER" ]; then
    echo -e "\e[31mFailed to start container\e[0m"
    exit 1
else
    echo "$TAG container $CONTAINER started. Waiting to start up"
fi

sleep 5

for port in 8051 8052 8053 8054 8055 8056 8070 8071 8072; do
    result=$(curl --silent http://localhost:$port/ |grep -Po 'PHP Version \d+.\d+.\d+')
    if [ -z "$result" ]; then
        echo -e "Port $port: \e[31mFAILED\e[0m"
    else
        echo -e "Port $port: \e[32m$result\e[0m"
    fi
done

echo "Checking extensions..."
echo
echo
php extensions.php
echo
echo

docker kill $CONTAINER
docker rm $CONTAINER
