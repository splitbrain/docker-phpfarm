phpfarm for docker
==================

This is a build file to create a [phpfarm](http://sourceforge.net/projects/phpfarm/)
setup. The resulting docker image will run Apache on 4 different ports with 4
different PHP versions:

Port | PHP Version
-----|-------------
8052 | 5.2.17
8053 | 5.3.28
8054 | 5.4.24
8055 | 5.5.8

Building the image
------------------

After checkout, simply run the following command:

  docker build -t splitbrain/phpfarm .

Running the container
---------------------

The following will run the container and map all ports to their respective ports on the
local machine. The current working directory will be used as the document root for
the Apache servers.

  docker run -rm -t -i -v $PWD:/var/www -p 8052:8052 -p 8053:8053 -p 8054:8054 -p 8055:8055 splitbrain/phpfarm

Above command will also remove the container again when the process is aborted with
CTRL-C
