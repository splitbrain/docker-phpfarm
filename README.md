phpfarm for docker
==================

This is a build file to create a [phpfarm](http://sourceforge.net/projects/phpfarm/)
setup. The resulting docker image will run Apache on 5 different ports with 5
different PHP versions:

Port | PHP Version
-----|-------------
8052 | 5.2.17
8053 | 5.3.29
8054 | 5.4.44
8055 | 5.5.28
8056 | 5.6.12

Building the image
------------------

After checkout, simply run the following command:

    docker build -t splitbrain/phpfarm .

This will setup a base Debian system, install phpfarm, download and compile the four
PHP versions and setup Apache. So, yes this will take a while. See the next section
for a faster alternative.

Downloading the image
-----------------

Simply downloading the ready made image from index.docker.io is probably the fastest
way. Just run this:

    docker pull splitbrain/phpfarm

Please note that this image might be somewhat behind from what the Dockerfile would
build, but my upload speed is too limited to upload a gigabyte in a timely fashion.

Running the container
---------------------

The following will run the container and map all ports to their respective ports on the
local machine. The current working directory will be used as the document root for
the Apache server and the server it self will run with the same user id as your current
user.

    docker run --rm -t -i -e APACHE_UID=$UID -v $PWD:/var/www:rw -p 8052:8052 -p 8053:8053 -p 8054:8054 -p 8055:8055 -p 8056:8056 splitbrain/phpfarm

Above command will also remove the container again when the process is aborted with
CTRL-C. While running the Apache and PHP error log is shown on STDOUT.

Note: the entry point for this image has been defined as ''/bin/bash'' and it will
run our ''run.sh'' by default. You can specify other parameters to be run by bash
of course.

To Do
-----

- [ ] adjust the build process to have a single file to configure PHP versions and ports
- [ ] optimize the Dockerfile to be more space and update efficient
- [ ] add more common PHP modules to be built

Feedback
--------

This is the first time I ever worked with docker. Pullrequests and hints on how
to improve the process are more than welcome.
