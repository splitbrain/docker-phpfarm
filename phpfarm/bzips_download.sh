#!/usr/bin/env bash

# Download Bzips for newer PHP versions not downloadable by compile.sh from
# museum.php.net or php.net.
# See https://github.com/fpoirotte/phpfarm/blob/v0.2.0/src/compile.sh

PHP_VERSIONS=(
  7.2.0beta1
)

PHP_BZIPS=(
  https://downloads.php.net/~pollita/php-7.2.0beta1.tar.bz2
)

mkdir -p bzips
cd bzips

for KEY in ${!PHP_VERSIONS[@]}; do
  VER=${PHP_VERSIONS[$KEY]}
  BZIP_URL=${PHP_BZIPS[$KEY]}

  wget -O php-$VER.tar.bz2 $BZIP_URL
done

