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
    8055 | 5.5.32      | php-5.5
    8056 | 5.6.18      | php-5.6
    8070 | 7.0.3       | php-7.0

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

Supported PHP modules
---------------------

All versions should support the most basic PHP modules as well as sqlite (or it's PDO
versions) and libgd. All versions should support pdo\_mysql as well.

Running the container without a volume will show a phpinfo() on all ports with
more details on what's available.

    docker run --rm -t -i -e APACHE_UID=$UID \
    -p 8052:8052 -p 8053:8053 -p 8054:8054 -p 8055:8055 -p 8056:8056 -p 8070:8070 \
    splitbrain/phpfarm:jessie

