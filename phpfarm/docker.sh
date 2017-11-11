#!/bin/bash
# this script builds everything for docker


if [ -z "$PHP_FARM_VERSIONS" ]; then
    echo "PHP versions not set! Aborting setup" >&2
    exit 1
fi

# fix freetype for older php https://stackoverflow.com/a/26342869
mkdir /usr/include/freetype2/freetype
ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h

# build and symlink to major.minor
for VERSION in $PHP_FARM_VERSIONS
do
    cd /phpfarm/src # make absolutely sure we're in the correct directory

    echo "--- compiling version $VERSION -----------------------------------------"
    # download the bzip
    ./phpdl.sh $VERSION /phpfarm/src/bzips

    V=$(echo $VERSION | awk -F. '{print $1"."$2}')

    # compile the PHP version
    ./compile.sh $VERSION
    ln -s "/phpfarm/inst/php-$VERSION/" "/phpfarm/inst/php-$V"
    ln -s "/phpfarm/inst/bin/php-$VERSION" "/phpfarm/inst/bin/php-$V"
    ln -s "/phpfarm/inst/bin/php-cgi-$VERSION" "/phpfarm/inst/bin/php-cgi-$V"
    ln -s "/phpfarm/inst/bin/phpize-$VERSION" "/phpfarm/inst/bin/phpize-$V"
    ln -s "/phpfarm/inst/bin/php-config-$VERSION" "/phpfarm/inst/bin/php-config-$V"

    # compile xdebug
    if [ "$V" == "5.1" ] || [ "$V" == "5.2" ] || [ "$V" == "5.3" ]; then
        XDBGVERSION="XDEBUG_2_2_7" # old release for old PHP versions
    elif [ "$V" == "5.4" ]; then
        XDBGVERSION="XDEBUG_2_4_1" # old release for old PHP versions
    elif [[ $VERSION == *"RC"* ]]; then
        XDBGVERSION="master"       # master for RCs
    else
        XDBGVERSION="XDEBUG_2_5_1" # stable release for all others
    fi

    echo "--- compiling xdebug $XDBGVERSION for php $VERSION ---------------------"

    wget https://github.com/xdebug/xdebug/archive/$XDBGVERSION.tar.gz && \
    tar -xzvf $XDBGVERSION.tar.gz && \
    cd xdebug-$XDBGVERSION && \
    phpize-$V && \
    ./configure --enable-xdebug --with-php-config=/phpfarm/inst/bin/php-config-$V && \
    make && \
    cp -v modules/xdebug.so /phpfarm/inst/php-$V/lib/ && \
    echo "zend_extension_debug = /phpfarm/inst/php-$V/lib/xdebug.so" >> /phpfarm/inst/php-$V/etc/php.ini && \
    echo "zend_extension = /phpfarm/inst/php-$V/lib/xdebug.so" >> /phpfarm/inst/php-$V/etc/php.ini && \
    cd .. && \
    rm -rf xdebug-$XDBGVERSION && \
    rm -f $XDBGVERSION.tar.gz && \
    cat xdebug.ini >> /phpfarm/inst/php-$V/etc/php.ini

    # enable apache config - compatible with wheezy and jessie
    a2ensite php-$V.conf
done

# print what have installed
ls -l /phpfarm/inst/bin/

# enable rewriting
a2enmod rewrite

# remove defaults
a2dissite 000-default
echo > /etc/apache2/ports.conf

# clean up sources
rm -rf /phpfarm/src
apt-get clean
rm -rf /var/lib/apt/lists/*

