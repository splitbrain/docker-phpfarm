phpfarm for docker
==================

This is a build file to create a [phpfarm](http://sourceforge.net/projects/phpfarm/)
setup. The resulting docker image will run Apache on different ports with different
PHP versions:

    Port | PHP Version | Binary
    -----|----------------------
    8052 | 5.2.17      | php-5.2 (wheezy only)
    8053 | 5.3.29      | php-5.3
    8054 | 5.4.44      | php-5.4
    8055 | 5.5.33      | php-5.5
    8056 | 5.6.19      | php-5.6
    8070 | 7.0.4       | php-7.0

There are two tags for this image: ``wheezy`` and ``jessie``, referring to the
underlying Debian base system releases. If you need PHP 5.2 you have to use the
``wheezy`` tag, otherwise the ``jessie`` provides a more modern environment.

Building the image
------------------

After checkout, simply run the following command:

    docker build -t splitbrain/phpfarm:jessie -f Dockerfile-Jessie .
    docker build -t splitbrain/phpfarm:wheezy -f Dockerfile-Wheezy .

This will setup a base Debian system, install phpfarm, download and compile the four
PHP versions and setup Apache. So, yes this will take a while. See the next section
for a faster alternative.

Downloading the image
-----------------

Simply downloading the ready made image from Docker Hub is probably the fastest
way. Just run one of these:

    docker pull splitbrain/phpfarm:wheezy
    docker pull splitbrain/phpfarm:jessie

Running the container
---------------------

The following will run the container and map all ports to their respective ports on the
local machine. The current working directory will be used as the document root for
the Apache server and the server it self will run with the same user id as your current
user.

    docker run --rm -t -i -e APACHE_UID=$UID -v $PWD:/var/www:rw \
    -p 8052:8052 -p 8053:8053 -p 8054:8054 -p 8055:8055 -p 8056:8056 -p 8070:8070 \
    splitbrain/phpfarm:jessie

Above command will also remove the container again when the process is aborted with
CTRL-C. While running the Apache and PHP error log is shown on STDOUT.


You can also access the PHP binaries within the container directly. Refer to the table
above for the correct names. The follwoing command will run PHP 5.3 on your current
working directory.

    docker run --rm -t -i -v $PWD:/var/www:rw splitbrain/phpfarm:jessie php-5.3 --version

Loading custom php.ini settings
-------------------------------

All PHP versions are compile with the config-file-scan-dir pointing to
``/var/www/.php/``. When mounting your own project as a volume to
``/var/www/`` you can easily place custom ``.ini`` files in the .php directory
and the should be automatically be picked up by PHP.

Supported PHP extensions
------------------------

Here's a list of the extensions available in each of the PHP versions. It should
cover all the default extensions plus a few popular ones and xdebug for debugging.

      Extension | PHP 5.2 | PHP 5.3 | PHP 5.4 | PHP 5.5 | PHP 5.6 | PHP 7.0
    ------------+---------+---------+---------+---------+---------+---------
         bcmath |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
            bz2 |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
       calendar |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
       cgi-fcgi |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
          ctype |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
           curl |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
           date |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
            dom |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
           ereg |         |    ✓    |    ✓    |    ✓    |    ✓    |
           exif |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
       fileinfo |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
         filter |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
            ftp |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
             gd |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
        gettext |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
           hash |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
          iconv |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
           imap |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
           intl |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
           json |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
           ldap |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
         libxml |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
       mbstring |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
         mcrypt |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
          mhash |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
          mysql |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
         mysqli |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
        mysqlnd |         |         |    ✓    |    ✓    |    ✓    |    ✓
        openssl |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
          pcntl |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
           pcre |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
            pdo |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
      pdo_mysql |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
      pdo_pgsql |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
     pdo_sqlite |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
          pgsql |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
           phar |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
          posix |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
     reflection |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
        session |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
      simplexml |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
           soap |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
        sockets |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
            spl |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
         sqlite |    ✓    |    ✓    |         |         |         |
        sqlite3 |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
       standard |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
      tokenizer |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
           wddx |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
         xdebug |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
            xml |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
      xmlreader |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
      xmlwriter |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
            xsl |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
            zip |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
           zlib |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓

