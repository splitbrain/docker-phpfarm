#!/bin/bash

VERSION=$1
DIR=$2
OUT="$DIR/php-$VERSION.tar.bz2"
EXT="$DIR/../php-$VERSION"

# print a message to STDERR and die
die() {
    echo $1 >&2
    exit 1
}

# check parameters
[ -z "$VERSION" ] && die "no version given"
[ -z "$DIR" ] && die "no output directory given"

# create output directory
if [ ! -d "$DIR" ]; then
    mkdir -p "$DIR" || die "failed to create output directory"
fi
if [ ! -d "$EXT" ]; then
    mkdir -p "$EXT" || die "failed to create extraction directory"
fi

# construct URL
if [[ $VERSION == *"RC"* ]]; then
    URL="https://downloads.php.net/~pollita/php-$VERSION.tar.bz2"
elif [[ $VERSION == "x.x.x" ]]; then
    URL="https://github.com/php/php-src/tarball/master"
    OUT="$DIR/php-$VERSION.tar.gz"
elif [ $VERSION \< "5.6" ]; then
    URL="http://museum.php.net/php5/php-$VERSION.tar.bz2"
else
    URL="http://php.net/get/php-$VERSION.tar.bz2/from/this/mirror"
fi

# do nothing if file exists
[ -f "$OUT" ] && exit 0

# download
echo "downloading $URL -> $OUT, extracting to $EXT"
curl -L --silent --show-error --fail -o "$OUT" "$URL" && \
tar -xvf "$OUT" -C "$EXT" --strip-components 1
exit $?
