FROM maxder/alpine-base:edge
MAINTAINER Christian-Maxilian Steier

ENV MAHARA_VERSION 15.10
ENV MAHARA_RELEASE 1

RUN apk --update add \
	php-common \
	php-iconv \
	php-json \
	php-gd \
	php-curl \
	php-xml \
	php-imap \
    	php-opcache \
    	php-apcu \
	php-cgi \
	fcgi \
	php-pdo \
	php-soap \
	php-xmlrpc \
	php-posix \
	php-mcrypt \
	php-gettext \
	php-ldap \
	php-ctype \
	php-dom \
	php-openssl \
	php-ftp \
	php-zlib \
	php-zip \
    	memcached \
    	libmemcached \
    	imagemagick \
    	bzip2 \
	graphviz \
    	php-pdo_mysql \
    	php-mysqli \
   	mysql-client \
    	pwgen \
	apache2 \
	php-apache2 \
 && rm -f /var/cache/apk/*

ADD service /etc/service
RUN chmod +x /etc/service/*/*

RUN echo "ServerName localhost" > /etc/apache2/conf.d/fqdn.conf

## PHP config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 512M/g" /etc/php/php.ini \
 && sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 512M/g" /etc/php/php.ini \
 && sed -i -e "s/short_open_tag\s*=\s*Off/short_open_tag = On/g" /etc/php/php.ini

RUN echo "apc.shm_size = 128M" >> /etc/php/conf.d/apcu.ini \
 && echo "apc.ttl=7200" >> /etc/php/conf.d/apcu.ini \
 && echo "apc.user_ttl=7200" >> /etc/php/conf.d/apcu.ini \
 && echo "apc.gc_ttl=3600" >> /etc/php/conf.d/apcu.ini

## Mahara
RUN cd /tmp \
 && wget https://launchpad.net/mahara/${MAHARA_VERSION}/${MAHARA_VERSION}.${MAHARA_RELEASE}/+download/mahara-${MAHARA_VERSION}.${MAHARA_RELEASE}.tar.gz \
 && tar -xvzf mahara-* \
 && rm *.tar.gz \
 && mv /tmp/mahara-*/htdocs /var/www/localhost/htdocs/mahara \
 && chown -R apache:apache /var/www/localhost/htdocs/mahara \
 && rm -r /tmp/mahara*
RUN mkdir /var/maharadata \
 && chown -R apache:apache /var/maharadata \
 && chmod 777 /var/maharadata \
 && touch /var/log/mahara_cron.log \
 && chown -R apache:apache /var/log/mahara_cron.log
RUN echo "* * * * * apache php /var/www/htdocs/mahara/lib/cron.php >> /var/log/mahara_cron.log 2>&1" >> /etc/crontab
RUN sed -i "s*5.0.25*05.0.25*g" /var/www/localhost/htdocs/mahara/init.php

RUN touch /firstrun

# Define mountable directories.
VOLUME ["/var/www/localhost/htdocs//mahara", "/var/maharadata"]

EXPOSE 80

ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
