FROM maxder/debianbase
MAINTAINER Christian-Maximilian Steier
ENV OWNCLOUD_VERSION 8.1
ENV OWNCLOUD_RELEASE 1

RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    apache2 \
    libapache2-mod-php5 \
    php5 \
    php5-gd \
    php-xml-parser \
    php5-intl \
    php5-mysqlnd \
    php5-json \
    php5-mcrypt \
    php5-apcu \
    php5-memcache \
    memcached \
    smbclient \
    php5-curl \
    bzip2 \
    graphviz \
    wget \
    libav-tools \
    mariadb-client \
    pwgen

# Adding additional memcached daemon
RUN mkdir /etc/service/memcached
ADD service/memcached.sh /etc/service/memcached/run
RUN chmod +x /etc/service/memcached/run

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## PHP config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 500M/g" /etc/php5/apache2/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 500M/g" /etc/php5/apache2/php.ini
RUN sed -i -e "s/short_open_tag\s*=\s*Off/short_open_tag = On/g" /etc/php5/apache2/php.ini

## Fixes: PHP is configured to populate raw post data. Since PHP 5.6 this will lead to PHP throwing notices for perfectly valid code. #19
RUN echo 'always_populate_raw_post_data = -1' | tee --append /etc/php5/cli/php.ini 

## Allow usage of `sudo -u www-data php /var/www/owncloud/occ` with APC.
## FIXME: Temporally: https://github.com/owncloud/core/issues/17329
RUN echo 'apc.enable_cli = 1' >> /etc/php5/cli/php.ini

RUN curl -k https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.${OWNCLOUD_RELEASE}.tar.bz2 | tar jx -C /var/www/
RUN mkdir /data
RUN chown -R www-data:www-data /var/www/owncloud
RUN echo "*/15  *  *  *  * php -f /var/www/owncloud/cron.php" >> /etc/cronttab
ADD conf/autoconfig.php /autoconfig.php
RUN chown -R www-data:www-data /data 

# Apache2
ADD conf/apache-default.conf /etc/apache2/sites-available/000-default.conf
RUN \
        a2enmod rewrite headers deflate \
        && echo "ServerName localhost" >> /etc/apache2/apache2.conf \
        && sed -i "s*NameVirtualHost*#NameVirtualHost*g" /etc/apache2/ports.conf

# Manually set the apache environment variables in order to get apache to work immediately. 
RUN echo www-data > /etc/container_environment/APACHE_RUN_USER
RUN echo www-data > /etc/container_environment/APACHE_RUN_GROUP
RUN echo /var/log/apache2 > /etc/container_environment/APACHE_LOG_DIR
RUN echo /var/lock/apache2 > /etc/container_environment/APACHE_LOCK_DIR
RUN echo /var/run/apache2.pid > /etc/container_environment/APACHE_PID_FILE

# Add apache to runit 
RUN mkdir /etc/service/apache
ADD service/apache.sh /etc/service/apache/run
RUN chmod +x /etc/service/apache/run

# User
RUN usermod -c "ownCloud" root && usermod -c "ownCloud" www-data

ADD scripts/first_run.sh /etc/my_init.d/firstrun.sh
RUN chmod +x /etc/my_init.d/firstrun.sh
RUN touch /firstrun

VOLUME ["/data", "/var/www/owncloud/config"]
EXPOSE 80
