#!/usr/bin/env bash

# Test the Docker image to see if it runs PHP successfully.
# Usage: test.sh [tag]
#   Where tag is the image tag you want to test. Can be 'latest', 'jessie' or
#   'wheezy'.

# Name of Docker image to test.
DOCKER_IMG=splitbrain/phpfarm

# Tag of image to test e.g. 'latest', 'wheezy'.
TAG=$1


if [ -z "$TAG" ]; then
    TAG=jessie
fi

# Ports to test for.
if [ "$TAG" = jessie ]; then
    # Debian:Jessie supports PHP 5.3 and above only.
    ports='8053 8054 8055 8056 8070 8071 8072 8073 8074 8080 8000'
else
    # Debian:Wheezy supports all versions til 7.2, no nightlies
    ports='8051 8052 8053 8054 8055 8056 8070 8071 8072'
fi

# Create the docker run option for publishing ports.
# E.g. -p 8051:8051 -p 8052:8052 ...
publishOption=''
for port in $ports; do
  publishOption="$publishOption -p ${port}:${port}"
done

container=$( docker run -d $publishOption $DOCKER_IMG:$TAG )

if [ -z "$container" ]; then
    echo -e "\e[31mFailed to start container\e[0m"
    exit 1
else
    echo "$TAG container $container started. Waiting to start up"
fi

# Wait for container to start.
sleep 5s

# Record results of the port test.
portTestResult=0

# Test if all required ports are showing a PHP version.
for port in $ports; do

    if [ -z "$CIRCLECI" ]; then
        # Not in Circle CI, curl to localhost to access container directly.
        result=$(curl --silent http://localhost:$port/ | grep -Eo 'PHP Version [0-9]+\.[0-9]+\.[0-9]+')
    else
        # In CircleCI, cannot access container port via localhost.
        # Build runner and created Docker containers run in separate
        # environments. So scripts in build runner (the job) cannot
        # communicate with Docker services.
        result=$(docker exec $container curl --silent http://localhost:$port/ | grep -Eo 'PHP Version [0-9]+\.[0-9]+\.[0-9]+')
    fi

    if [ -z "$result" ]; then
        echo -e "Port $port: \e[31mFAILED\e[0m"
        # Set port test result to "error" (non-zero) if any port test fails.
        portTestResult=1
    else
        echo -e "Port $port: \e[32m$result\e[0m"
    fi
done

# Display status of PHP extensions.
# extensions.php curls to localhost, which doesn't work in a CircleCI env
# where we cannot access the created container directly.
if [ -z "$CIRCLECI" ]; then
    echo -e 'Checking extensions...\n\n'
    php extensions.php
fi

docker kill $container
docker rm $container

# Return the port test result as representing the entire script's result.
exit $portTestResult

