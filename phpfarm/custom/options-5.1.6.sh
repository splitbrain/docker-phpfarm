# custom options file for phpfarm


# Apply patches for building PHP 5.1.6

patchDir='/phpfarm/src/custom/patches-5.1.6'

patch -d $srcdir -p0 < $patchDir/curl.patch
patch -d $srcdir -p0 < $patchDir/openssl.patch
patch -d $srcdir -p0 < $patchDir/pdo_oci.patch
patch -d $srcdir -p0 < $patchDir/imap.patch


# no intl on 5.1.6
configoptions=`echo "$configoptions" |sed 's/--enable-intl//'`

configoptions="$configoptions --enable-fastcgi"

echo "--- loaded custom/options-5.1.6.sh ---"
echo $configoptions
echo "---------------------------------------"
