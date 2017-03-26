# custom options file for phpfarm


# Apply patches for building PHP 5.1.6

patchDir='/phpfarm/src/custom/patches-5.1.6'

patch -d $srcdir -p0 < $patchDir/curl.patch
# patch -d $srcdir -p0 < $patchDir/openssl.patch
patch -d $srcdir -p0 < $patchDir/pdo_oci.patch
patch -d $srcdir -p0 < $patchDir/imap.patch
# patch -d $srcdir -p0 < $patchDir/mysqli.patch
# patch -d $srcdir -p0 < $patchDir/mysqli-2.patch


# no intl on 5.1.6
configoptions=`echo "$configoptions" |sed 's/--enable-intl//'`

# OpenSSL and MySQLi options result in unresolvable errors due to
# incompatibilities with existing libraries - leave them out.
# MySQLi extension can be compiled later using PHPize, see http://gunner.me/archives/403
configoptions=`echo "$configoptions" |sed 's/--with-openssl//'`
# Remove '--with-mysqli=/path/to/config'
configoptions=`echo "$configoptions" |sed 's/--with-mysqli\(=[^ ]\+\)\?//'`

# Required to build FastCGI interpreter.
configoptions="$configoptions --enable-fastcgi"


echo "--- loaded custom/options-5.1.6.sh ---"
echo $configoptions
echo "---------------------------------------"
