#!/bin/bash
# this script builds everything for docker

if [ -z "$PHP_FARM_VERSIONS" ]; then
    echo "PHP versions not set! Aborting setup" >&2
    exit 1
fi

# build and symlink to major.minor
for VERSION in $PHP_FARM_VERSIONS
do
    V=$(echo $VERSION | awk -F. '{print $1"."$2}')
    ./compile.sh $VERSION
    ln -s "/phpfarm/inst/php-$VERSION/" "/phpfarm/inst/php-$V"
    ln -s "/phpfarm/inst/bin/php-$VERSION" "/phpfarm/inst/bin/php-$V"
    ln -s "/phpfarm/inst/bin/php-cgi-$VERSION" "/phpfarm/inst/bin/php-cgi-$V"

    # enable apache config
    a2ensite php-$V
done

# enable rewriting
a2enmod rewrite

# clean up sources
rm -rf /phpfarm/src
apt-get clean
rm -rf /var/lib/apt/lists/*
