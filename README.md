phpfarm for docker
==================

This is a build file to create a [phpfarm](https://github.com/fpoirotte/phpfarm)
setup. The resulting docker image will run Apache on different ports with different
PHP versions accessed via FCGI. The different PHP CLI binaries are accessible as
well.

[![CircleCI](https://circleci.com/gh/eugenesia/docker-phpfarm.svg?style=shield)](https://circleci.com/gh/eugenesia/docker-phpfarm)


Port | PHP Version | Binary
-----|-------------|-----------------------
8051 | 5.1.6       | php-5.1 (wheezy only)
8052 | 5.2.17      | php-5.2 (wheezy only)
8053 | 5.3.29      | php-5.3
8054 | 5.4.44      | php-5.4
8055 | 5.5.38      | php-5.5
8056 | 5.6.31      | php-5.6
8070 | 7.0.21      | php-7.0
8071 | 7.1.7       | php-7.1
8072 | 7.2.0beta1  | php-7.2

There are two tags for this image: ``wheezy`` and ``jessie``, referring to the
underlying Debian base system releases. If you need PHP 5.1 or 5.2 you have to
use the ``wheezy`` tag, otherwise the ``jessie`` image provides a more modern
environment.

Building the image
------------------

After checkout, simply run the following command:

    docker build -t eugenesia/phpfarm:jessie -f Dockerfile-Jessie .
    docker build -t eugenesia/phpfarm:wheezy -f Dockerfile-Wheezy .

This will setup a Debian base system, install phpfarm, download and compile the different
PHP versions, extensions and setup Apache. So, yes this will take a while. See the next
section for a faster alternative.

Downloading the image
-----------------

Simply downloading the ready made image from Docker Hub is probably the fastest
way. Just run one of these:

    docker pull eugenesia/phpfarm:wheezy
    docker pull eugenesia/phpfarm:jessie

Running the container
---------------------

The following will run the container and map all ports to their respective ports on the
local machine. The current working directory will be used as the document root for
the Apache server and the server itself will run with the same user id as your current
user.

    docker run --rm -t -i -e APACHE_UID=$UID -v $PWD:/var/www:rw \
      -p 8051:8051 -p 8052:8052 -p 8053:8053 -p 8054:8054 -p 8055:8055 \
      -p 8056:8056 -p 8070:8070 -p 8071:8071 -p 8072:8072 \
      eugenesia/phpfarm:jessie

Above command will also remove the container again when the process is aborted with
CTRL-C. While running, the Apache and PHP error log is shown on STDOUT.

You can also access the PHP binaries within the container directly. Refer to the table
above for the correct names. The following command will run PHP 5.3 on your current
working directory.

    docker run --rm -t -i -v $PWD:/var/www:rw eugenesia/phpfarm:jessie php-5.3 --version

Alternatively you can also run an interactive shell inside the container with
your current working directory mounted.

    docker run --rm -t -i -v $PWD:/var/www:rw eugenesia/phpfarm:jessie /bin/bash

Loading custom php.ini settings
-------------------------------

All PHP versions are compiled with the config-file-scan-dir pointing to
``/var/www/.php/``. When mounting your own project as a volume to
``/var/www/`` you can easily place custom ``.ini`` files in your project's ``.php``
directory and they should be automatically be picked up by PHP.

Using the image for Testing in Gitlab-CI
----------------------------------------

[Gitlab-CI](https://about.gitlab.com/gitlab-ci/) users can use this image to automate
testing against different PHP versions. For detailed info refer to the gitlab-ci
documentation.

Here's a simple ``.gitlab-ci.yml`` example using phpunit.

    stages:
      - test

    image: eugenesia/phpfarm:jessie

    php-5.3:
      stage: test
      script:
        - wget https://phar.phpunit.de/phpunit-old.phar -O phpunit
        - php-5.3 phpunit --coverage-text --colors=never

    php-5.4:
      stage: test
      script:
        - wget https://phar.phpunit.de/phpunit-old.phar -O phpunit
        - php-5.4 phpunit --coverage-text --colors=never

    php-5.6:
      stage: test
      script:
        - wget https://phar.phpunit.de/phpunit.phar -O phpunit
        - php-5.6 phpunit --coverage-text --colors=never

    php-7.0:
      stage: test
      script:
        - wget https://phar.phpunit.de/phpunit.phar -O phpunit
        - php-7.0 phpunit --coverage-text --colors=never

Supported PHP extensions
------------------------

Here's a list of the extensions available in each of the PHP versions. It should
cover all the default extensions plus a few popular ones and xdebug for debugging.

Extension    | PHP 5.1 | PHP 5.2 | PHP 5.3 | PHP 5.4 | PHP 5.5 | PHP 5.6 | PHP 7.0 | PHP 7.1 | PHP 7.2
------------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:|:-------:
bcmath       |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
bz2          |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
calendar     |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
cgi-fcgi     |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
ctype        |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
curl         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
date         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
dom          |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
ereg         |         |         |    ✓    |    ✓    |    ✓    |    ✓    |         |         |
exif         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
fileinfo     |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
filter       |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
ftp          |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
gd           |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
gettext      |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
hash         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
iconv        |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
imap         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
intl         |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
json         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
ldap         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
libxml       |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
mbstring     |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
mcrypt       |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
mhash        |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |         |         |
mysql        |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |         |         |
mysqli       |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
mysqlnd      |         |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
openssl      |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
pcntl        |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
pcre         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
pdo          |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
pdo_mysql    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
pdo_pgsql    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
pdo_sqlite   |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
pgsql        |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
phar         |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
posix        |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
reflection   |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
session      |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
simplexml    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
soap         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
sockets      |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
spl          |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
sqlite       |    ✓    |    ✓    |    ✓    |         |         |         |         |         |
sqlite3      |         |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
standard     |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
tokenizer    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
wddx         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
xdebug       |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |
xml          |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
xmlreader    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
xmlwriter    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
xsl          |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
zip          |         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓
zlib         |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓    |    ✓

