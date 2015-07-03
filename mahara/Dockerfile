FROM eboraas/debootstrap:minbase-jessie
MAINTAINER Christian-Maxilian Steier
ENV MAHARA_VERSION 15.04
ENV MAHARA_RELEASE 1
ENV ELASTICSEARCH_VERSION 1.6.0
#ENV VIRTUAL_HOST domain.org

ADD http://http.debian.net/debian/project/trace/ftp-master.debian.org /etc/trace_ftp-master.debian.org
ADD http://security.debian.org/project/trace/security-master.debian.org /etc/trace_security-master.debian.org

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl
# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Set timezone
RUN echo "Europe/Berlin" > /etc/timezone \ 
 && dpkg-reconfigure -f noninteractive tzdata

# Missing keys
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9D6D8F6BC857C906 \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7638D0442B90D010
 
# Basic Requirements
RUN apt-get update \ 
 && apt-get -y install \ 
	pwgen \
	python-setuptools \
	curl \
	wget \
	git \
	unzip

# Mahara Requirements
RUN apt-get -y install \
	apache2 \
	cron \
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
	php5-mysql \
	php5-imagick \
	php-xml-parser \
	php5-intl \
	php5-xcache \
	php-services-json \
	php5-adodb \
	tinymce \
	ttf-bitstream-vera \
	ttf-freefont

 
# Set timezone in cli and apache config
RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Europe\/Berlin/g' /etc/php5/cli/php.ini \
&& sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Europe\/Berlin/g' /etc/php5/apache2/php.ini

# SSH
RUN apt-get -y install openssh-server
RUN mkdir -p /var/run/sshd

# MariaDB
RUN apt-get -y install mariadb-server mariadb-client
ADD scripts/mariadb.sh /tmp/mariadb.sh
RUN chmod +x /tmp/mariadb.sh
RUN /tmp/mariadb.sh
RUN rm /tmp/mariadb.sh

RUN easy_install supervisor
ADD scripts/start.sh /start.sh
RUN sed -i "s*MAHARA_VERSION*${MAHARA_VERSION}*g" /start.sh
ADD scripts/foreground.sh /etc/apache2/foreground.sh
ADD conf/supervisord.conf /etc/supervisord.conf

## PHP config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/apache2/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/apache2/php.ini
RUN sed -i -e "s/short_open_tag\s*=\s*Off/short_open_tag = On/g" /etc/php5/apache2/php.ini

## Mahara
RUN cd /tmp \
 && wget https://launchpad.net/mahara/${MAHARA_VERSION}/${MAHARA_VERSION}.${MAHARA_RELEASE}/+download/mahara-${MAHARA_VERSION}.${MAHARA_RELEASE}.tar.gz \
 && tar -xf mahara-* \
 && rm *.tar.gz 
RUN cp -ax /tmp/mahara-*/htdocs /var/www/html/mahara
RUN chown -R www-data:www-data /var/www/html/mahara
RUN rm -r /tmp/mahara*
RUN mkdir /var/maharadata
RUN chown -R www-data:www-data /var/maharadata; chmod 777 /var/maharadata
RUN touch /var/log/mahara_cron.log
RUN chown -R www-data:www-data /var/log/mahara_cron.log
RUN echo "* * * * * www-data php /var/www/html/mahara/lib/cron.php >> /var/log/mahara_cron.log 2>&1" >> /etc/crontab
RUN chmod 755 /start.sh /etc/apache2/foreground.sh
RUN sed -i "s*5.0.25*05.0.25*g" /var/www/html/mahara/init.php

## Mahara plugins
ADD scripts/mahara-plugins.sh /tmp/mahara-plugins.sh
RUN chmod +x /tmp/mahara-plugins.sh
RUN /tmp/mahara-plugins.sh
RUN rm /tmp/mahara-plugins.sh

## Java
RUN \
 echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list \
 && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update \
 && apt-get install -y oracle-java8-installer
# Define working directory.
WORKDIR /data
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

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22 3306 80 9200 9300
CMD ["/bin/bash", "/start.sh"]

