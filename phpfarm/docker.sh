#!/bin/bash

# this script builds everything for docker

VERSIONS="5.2.17 5.3.29 5.4.44 5.5.32 5.6.18 7.0.3"

# build and symlink to major.minor
for VERSION in $VERSIONS
do
    V=$(echo $VERSION | awk -F. '{print $1"."$2}')
    ./compile.sh $VERSION
    ln -s "/phpfarm/inst/php-$VERSION/" "/phpfarm/inst/php-$V"
    ln -s "/phpfarm/inst/bin/php-$VERSION" "/phpfarm/inst/bin/php-$V"
    ln -s "/phpfarm/inst/bin/php-cgi-$VERSION" "/phpfarm/inst/bin/php-cgi-$V"
done

# clean up sources
rm -rf /phpfarm/src
apt-get clean
rm -rf /var/lib/apt/lists/*
