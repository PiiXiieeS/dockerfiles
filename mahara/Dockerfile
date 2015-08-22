FROM maxder/debianbase
MAINTAINER Christian-Maxilian Steier

ENV MAHARA_VERSION 15.04
ENV MAHARA_RELEASE 3

RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Basic Requirements
RUN apt-get update \ 
 && apt-get -y install \ 
	pwgen \
	python-setuptools \
	curl \
	wget \
	git \
	unzip \
	inotify-tools \
	expect

# Install MariaDB from repository.
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server mariadb-client
ADD scripts /scripts
RUN chmod +x /scripts/start.sh
RUN touch /firstrun
RUN chmod +x /scripts/tuning_mariadb.sh
RUN /scripts/tuning_mariadb.sh

# Mahara Requirements
RUN apt-get -y install \
	apache2 \
	file \
	libjs-jquery \
	perl \
	php5 \
	php-file \
	php-htmlpurifier \
	php-pear \
	php5-cli \
	php5-curl \
	php5-gd \
	php5-mysqlnd \
	php5-imagick \
	php-xml-parser \
	php5-intl \
	php5-apcu \ 
	php-services-json \
	php5-adodb \
	php5-ldap \
	php5-memcache \
	memcached \
	tinymce \
	ttf-bitstream-vera \
	ttf-freefont

# Enable PHP 
RUN a2enmod php5

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

## PHP config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 500M/g" /etc/php5/apache2/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 500M/g" /etc/php5/apache2/php.ini
RUN sed -i -e "s/short_open_tag\s*=\s*Off/short_open_tag = On/g" /etc/php5/apache2/php.ini

# Adding additional memcached daemon
RUN mkdir /etc/service/memcached
ADD service/memcached.sh /etc/service/memcached/run
RUN chmod +x /etc/service/memcached/run

## Mahara
RUN cd /tmp \
 && wget https://launchpad.net/mahara/${MAHARA_VERSION}/${MAHARA_VERSION}.${MAHARA_RELEASE}/+download/mahara-${MAHARA_VERSION}.${MAHARA_RELEASE}.tar.gz \
 && tar -xf mahara-* \
 && rm *.tar.gz 
RUN cp -ax /tmp/mahara-*/htdocs /var/www/html/mahara
RUN chown -R www-data:www-data /var/www/html/mahara
RUN rm -r /tmp/mahara*
RUN mkdir /var/maharadata
RUN chown -R www-data:www-data /var/maharadata
RUN chmod 777 /var/maharadata
RUN touch /var/log/mahara_cron.log
RUN chown -R www-data:www-data /var/log/mahara_cron.log
RUN echo "* * * * * www-data php /var/www/html/mahara/lib/cron.php >> /var/log/mahara_cron.log 2>&1" >> /etc/crontab
RUN sed -i "s*5.0.25*05.0.25*g" /var/www/html/mahara/init.php

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3306

# Expose our data, log, and configuration directories.
#VOLUME ["/var/log/mysql", "/etc/mysql"]

# Use baseimage-docker's init system.
CMD ["/sbin/my_init", "--", "/scripts/start.sh"]
