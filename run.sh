#!/usr/bin/env bash

#
# Manage the running of Apache httpd.
#

# is a certain UID wanted?
if [ ! -z "$APACHE_UID" ]; then
    useradd --home /var/www --gid www-data -M -N --uid $APACHE_UID  wwwrun
    echo "export APACHE_RUN_USER=wwwrun" >> /etc/apache2/envvars
    chown -R wwwrun /var/lib/apache2
fi

# Get value of APACHE_LOG_DIR.
. /etc/apache2/envvars

# Direct logs to stdout/stderr so they will show in 'docker logs' command.
ln -sf /dev/stderr $APACHE_LOG_DIR/error.log
ln -sf /dev/stdout $APACHE_LOG_DIR/access.log
ln -sf /dev/stdout $APACHE_LOG_DIR/other_vhosts_access.log

# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/apache2.pid

# Start Apache in the foreground - Docker needs this to keep the container
# running.
apache2ctl -DFOREGROUND

# No need to tail as Apache log files link to stdout/stderr now.
# tail -f /var/log/apache2/error.log
