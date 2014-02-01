# we need the correct path, is there a better way to find it?
if [ -d "/lib/i386-linux-gnu" ]; then
    LIBPATH="/lib/i386-linux-gnu/"
else
    LIBPATH="/lib/x86_64-linux-gnu/"
fi


configoptions="$configoptions \
    --enable-fastcgi \
    --with-bz2 \
    --with-curl \
    --with-gd \
    --with-jpeg-dir=/usr/lib \
    --with-png-dir=/usr/lib \
    --enable-gd-native-ttf \
    --with-ttf \
    --with-mhash \
    --with-mcrypt \
    --with-libdir=$LIBPATH \
"

echo $configoptions
