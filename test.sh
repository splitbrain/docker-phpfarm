#!/usr/bin/env bash

# Test the Docker image to see if it runs PHP successfully.

# Name of Docker image to test.
DOCKER_IMAGE=eugenesia/phpfarm

# Tag of image to test e.g. 'latest', 'wheezy'.
TAG=$1


if [ -z $TAG ]; then
    TAG='jessie'
fi

# Ports to test for.
if [ $TAG -e 'jessie' ]; then
    # Debian:Jessie supports PHP 5.3 and above only.
    ports='8053 8054 8055 8056 8070 8071 8072'
else
    # Debian:Wheezy supports all versions.
    ports='8051 8052 8053 8054 8055 8056 8070 8071 8072'
fi

# Create the docker run option for publishing ports.
# E.g. -p 8051:8051 -p 8052:8052 ...
publishOption=''
for port in $ports; do
  publishOption="$publishOption -p 80${port}:80${port}"
done

container=$( docker run -d -e APACHE_UID=$UID \
    $publishOption \
    eugenesia/phpfarm:$TAG )

if [ -z "$container" ]; then
    echo -e "\e[31mFailed to start container\e[0m"
    exit 1
else
    echo "$TAG container $container started. Waiting to start up"
fi

sleep 5

# Record results of the port test.
portTestResult=0
for port in $ports; do
    result=$(curl --silent http://localhost:$port/ |grep -Po 'PHP Version \d+.\d+.\d+')
    if [ -z "$result" ]; then
        echo -e "Port $port: \e[31mFAILED\e[0m"
        # Set port test result to "error" (non-zero) if any port test fails.
        portTestResult=1
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

docker kill $container
docker rm $container

exit $portTestResult

