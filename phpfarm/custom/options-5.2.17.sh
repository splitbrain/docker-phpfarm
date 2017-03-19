# custom options file for phpfarm
# Applies the patch for https://bugs.php.net/bug.php?id=54736 when building PHP 5.2.17

curl 'https://bugs.php.net/patch-display.php?bug_id=54736&patch=debian_patches_disable_SSLv2_for_openssl_1_0_0.patch&revision=1305414559&download=1' | patch $srcdir/ext/openssl/xp_ssl.c

# no intl on 5.2
configoptions=`echo "$configoptions" |sed 's/--enable-intl//'`
configoptions="$configoptions --enable-fastcgi"

echo "--- loaded custom/options-5.2.17.sh ---"
echo $configoptions
echo "---------------------------------------"
