#
# PHP Farm Docker image
#

# we use Debian as the host OS
FROM philcryer/min-wheezy:latest

MAINTAINER Andreas Gohr, andi@splitbrain.org

# the PHP versions to compile
ENV PHP_FARM_VERSIONS "5.2.17 5.3.29 5.4.44 5.5.32 5.6.18 7.0.3"

# add some build tools
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    apache2-mpm-prefork \
    git \
    build-essential \
    wget \
    libxml2-dev \
    libssl-dev \
    libsslcommon2-dev \
    libcurl4-openssl-dev \
    pkg-config \
    curl \
    libapache2-mod-fcgid \
    libbz2-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libxpm-dev \
    libmcrypt-dev \
    libt1-dev \
    libltdl-dev \
    libmhash-dev \
    libmysqlclient-dev

# reconfigure Apache
RUN rm -rf /var/www/*
COPY var-www /var/www/
COPY apache  /etc/apache2/

# install the phpfarm script
RUN git clone https://github.com/cweiske/phpfarm.git phpfarm

# add customized configuration
COPY phpfarm /phpfarm/src/

# compile, then delete sources (saves space)
RUN cd /phpfarm/src && ./docker.sh

# set path
ENV PATH /phpfarm/inst/bin/:/usr/sbin:/usr/bin:/sbin:/bin

# expose the ports
EXPOSE 8052 8053 8054 8055 8056 8070

# run it
WORKDIR /var/www
COPY run.sh /run.sh
CMD ["/bin/bash", "/run.sh"]
