#
# PHP Farm Docker image
#

# we use Debian as the host OS
FROM debian:wheezy

MAINTAINER Andreas Gohr, andi@splitbrain.org

# add some build tools
RUN apt-get update
RUN apt-get install -y apache2 apache2-mpm-prefork git build-essential wget libxml2-dev libssl-dev libsslcommon2-dev libcurl4-openssl-dev pkg-config curl libapache2-mod-fcgid libbz2-dev libjpeg-dev libpng-dev libfreetype6-dev libxpm-dev libmcrypt-dev libt1-dev libltdl-dev libmhash-dev

# install and run the phpfarm script
RUN git clone git://git.code.sf.net/p/phpfarm/code phpfarm
ADD phpfarm/custom-options.sh /phpfarm/src/custom-options.sh
ADD phpfarm/custom-options-5.2.17.sh /phpfarm/src/custom-options-5.2.17.sh
ADD phpfarm/custom-php.ini /phpfarm/src/custom-php.ini
RUN cd /phpfarm/src && ./compile.sh 5.2.17
RUN cd /phpfarm/src && ./compile.sh 5.3.28
RUN cd /phpfarm/src && ./compile.sh 5.4.24
RUN cd /phpfarm/src && ./compile.sh 5.5.8

# reconfigure Apache
RUN rm -f /var/www/index.html
ADD apache/index.php /var/www/index.php
ADD apache/ports /etc/apache2/conf.d/ports
ADD apache/php-5.2 /etc/apache2/sites-available/php-5.2
ADD apache/php-5.3 /etc/apache2/sites-available/php-5.3
ADD apache/php-5.4 /etc/apache2/sites-available/php-5.4
ADD apache/php-5.5 /etc/apache2/sites-available/php-5.5
RUN a2ensite php-5.2
RUN a2ensite php-5.3
RUN a2ensite php-5.4
RUN a2ensite php-5.5

# expose the ports
EXPOSE 8052
EXPOSE 8053
EXPOSE 8054
EXPOSE 8055
