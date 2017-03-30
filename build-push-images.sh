#!/usr/bin/env bash

#
# Build and push the images.
# Turn on Docker experimental mode to enable the --squash functionality.
#

set -vx

docker build --squash -t eugenesia/phpfarm:jessie -f Dockerfile-Jessie . > /tmp/build-jessie.log 2>&1
docker push eugenesia/phpfarm:jessie

docker build --squash -t eugenesia/phpfarm:wheezy -f Dockerfile-Wheezy . > /tmp/build-wheezy.log 2>&1
docker push eugenesia/phpfarm:wheezy

set +vx
