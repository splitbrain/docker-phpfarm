#
# Post-build and install script for PHP 5.1.6.
#

version='5.1.6'
# PHP 5.1.6 sources.
srcDir="/phpfarm/src/php-$version"
# Installation dir.
instDir="/phpfarm/inst/php-$version"
# Bins for this PHP version.
binDir="$instDir/bin"

# Copy executables to the correct places and rename them.
#
# PHP 5.1 names both CGI and CLI executables 'php' which is incompatible with
# future PHP versions. Also, the CGI executable has overwritten the CLI
# executable in $binDir due to them having the same name - this fixes it.
cp $srcDir/sapi/cgi/php $binDir/php-cgi
cp $srcDir/sapi/cli/php $binDir/php

# Create links in shared bin dir to the actual bins.
sharedBinDir=/phpfarm/inst/bin
ln -fs $binDir/php-cgi $sharedBinDir/php-cgi-$version
ln -fs $binDir/php-config $sharedBinDir/php-config-$version
ln -fs $binDir/phpize $sharedBinDir/phpize-$version


#
# Extensions in php.ini.
#

# php.ini file for PHP version.
phpIniFile=$instDir/etc/php.ini

# Need to specify extension_dir then extension as just filename without path.
# As 'extension = /phpfarm/inst/php-5.1.6/lib/mysqli.so' doesn't work.
echo "extension_dir = $instDir/lib" >> $phpIniFile


#
# MySQLi extension.
#

# Dir where all patches are stored.
patchDir="/phpfarm/src/custom/patches-$version"

# Patch extension source before compiling.
patch -d $srcDir -p0 < $patchDir/mysqli.patch
patch -d $srcDir -p0 < $patchDir/mysqli-2.patch

# Compile mysqli extension separately. Compiling the extension together with
# PHP using --with-mysqli breaks. See http://gunner.me/archives/403
cd $srcDir/ext/mysqli
$binDir/phpize
./configure --with-php-config=$binDir/php-config --with-mysqli=/usr/bin/mysql_config
make

# Move compiled extension to extension dir.
cp modules/mysqli.so $instDir/lib/

# Load extension in php.ini.
echo 'extension = mysqli.so' >> $phpIniFile


#
# OpenSSL extension.
#

# Patch extension source before compiling.
patch -d $srcDir -p0 < $patchDir/openssl.patch

# Compile openssl extension separately. Compiling the extension together with
# PHP using --with-openssl breaks.
cd $srcDir/ext/openssl
# PHPize needs to find config.m4 to start due to bug https://bugs.php.net/bug.php?id=53571
cp config0.m4 config.m4
$binDir/phpize
./configure --with-php-config=$binDir/php-config --with-openssl
make

# Move compiled extension to extension dir.
cp modules/openssl.so $instDir/lib/

# Load extension in php.ini.
echo 'extension = openssl.so' >> $phpIniFile

