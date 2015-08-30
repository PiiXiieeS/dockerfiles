FROM maxder/debianbase
MAINTAINER Christian-Maxilian Steier

ENV MAHARA_VERSION 15.04
ENV MAHARA_RELEASE 3
ENV ELASTICSEARCH_VERSION 1.6.0

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

# Java 8
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update
# auto accept oracle jdk license
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer ca-certificates
# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Elasticsearch
RUN cd / \
 && wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-$ELASTICSEARCH_VERSION.zip \
 && unzip elasticsearch-$ELASTICSEARCH_VERSION.zip \
 && rm -f elasticsearch-$ELASTICSEARCH_VERSION.zip \
 && mv elasticsearch-$ELASTICSEARCH_VERSION /elasticsearch
# Define mountable directories.
VOLUME ["/data"]
# Mount elasticsearch.yml config
ADD conf/elasticsearch.yml /elasticsearch/config/elasticsearch.yml
# Define working directory.
WORKDIR /data
RUN mkdir /etc/service/elasticsearch
ADD service/elasticsearch.sh /etc/service/elasticsearch/run
RUN chmod +x /etc/service/elasticsearch/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Define mountable directories.
VOLUME ["/var/www/html/mahara", "/var/maharadata"]

EXPOSE 80
