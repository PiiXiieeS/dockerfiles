FROM maxder/debianbase
MAINTAINER Christian-Maxilian Steier

ENV MOODLE_VERSION 29

RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

ADD scripts/first_run.sh /etc/my_init.d/firstrun.sh
RUN chmod +x /etc/my_init.d/firstrun.sh
RUN touch /firstrun

# Basic Requirements
RUN apt-get update \ 
 && apt-get -y install \ 
	pwgen \
	python-setuptools \
	curl \
	wget \
	git \
	unzip \
	inotify-tools

# Moodle Requirements
RUN apt-get -y install \
	apache2 \
	file \
	libjs-jquery \
	perl \
	php5 \
	php-file \
	php-htmlpurifier \
	php-pear \
	php5-xmlrpc \
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
	ttf-freefont \
	mariadb-client

# MongoDB
RUN pecl install mongo

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
RUN echo 'always_populate_raw_post_data = -1' | tee --append /etc/php5/cli/php.ini
RUN echo 'apc.enable_cli = 1' >> /etc/php5/cli/php.ini

# Adding additional memcached daemon
RUN mkdir /etc/service/memcached
ADD service/memcached.sh /etc/service/memcached/run
RUN chmod +x /etc/service/memcached/run

# Moodle
ADD http://downloads.sourceforge.net/project/moodle/Moodle/stable${MOODLE_VERSION}/moodle-latest-${MOODLE_VERSION}.tgz /var/www/html/moodle-latest-${MOODLE_VERSION}.tgz
RUN cd /var/www/html && tar zxvf moodle-latest-${MOODLE_VERSION}.tgz \
 && chown -R www-data:www-data /var/www/html/moodle \
 && rm moodle-latest-${MOODLE_VERSION}.tgz \
 && mkdir /var/moodledata \
 && chown -R www-data:www-data /var/moodledata \
 && chmod 777 /var/moodledata
RUN echo "* * * * * www-data php /var/www/html/moodle/admin/cli/cron.php >/dev/null" >> /etc/crontab
RUN sed -i 's*DocumentRoot /var/www/html*DocumentRoot /var/www/html\n        RedirectMatch 303 ^/?\$ /moodle*g' /etc/apache2/sites-available/000-default.conf 
RUN usermod -c "Moodle" www-data

# Moosh by Tomasz Muras
RUN apt-add-repository 'deb http://ppa.launchpad.net/zabuch/ppa/ubuntu precise main' \
 && apt-get update \
 && apt-get install moosh

# Moodle plugins
ADD scripts/moodle-plugins.sh /moodle-plugins.sh
RUN chmod 755 /moodle-plugins.sh \
 && /bin/bash /moodle-plugins.sh \
 && rm /moodle-plugins.sh

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Define mountable directories.
VOLUME ["/var/www/html/moodle", "/var/moodledata"]

EXPOSE 80
