# custom options file for phpfarm


# Apply patches for building PHP 5.1.6

patchDir='/phpfarm/src/custom/patches-5.1.6'

# Patch extensions.
patch -b -d $srcdir -p0 < $patchDir/curl.patch
patch -b -d $srcdir -p0 < $patchDir/pdo_oci.patch
patch -b -d $srcdir -p0 < $patchDir/imap.patch

# Both CGI and CLI compile to 'php' which is incompatible with future versions.
# See: http://php.net/manual/en/features.commandline.introduction.php
# Patch CGI to make it build to 'php-cgi' instead of 'php'.
patch -b -d $srcdir -p0 < $patchDir/cgi.patch

# Another patch for CGI compile. And ensure that CLI is also compiled.
# Otherwise will result in 'no php found' error in compile.sh.
patch -b -d $srcdir -p0 < $patchDir/configure.patch

# Not needed for compile as they are only Autoconf template files and tests.
# patch -b -d $srcdir -p0 < $patchDir/configure.in.patch
# patch -b -d $srcdir -p0 < $patchDir/run-tests.patch

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
