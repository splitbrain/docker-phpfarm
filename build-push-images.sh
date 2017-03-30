#!/usr/bin/env bash

#
# Build and push the images.
#
# Usage: build-push-images.sh mydockerhubuser/myreponame
# E.g. build-push-images.sh eugenesia/phpfarm
#
# Turn on Docker experimental mode to enable the --squash functionality.
# See https://github.com/docker/docker/tree/master/experimental
#

if [ -z "$1" ]; then

  # Filename of this script.
  myscript=`basename "$0"`

  echo 'Please enter your Docker hub username and repo name in the format:'
  echo "$myscript mydockerhubuser/myreponame"

  exit 1
fi

# E.g eugenesia/phpfarm
hubUserRepo="$1"

set -vx

docker build --squash -t ${hubUserRepo}:jessie -f Dockerfile-Jessie . > /tmp/build-jessie.log 2>&1
docker push ${hubUserRepo}:jessie

docker build --squash -t ${hubUserRepo}:wheezy -f Dockerfile-Wheezy . > /tmp/build-wheezy.log 2>&1
docker push ${hubUserRepo}:wheezy

set +vx
