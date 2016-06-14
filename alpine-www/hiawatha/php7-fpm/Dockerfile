FROM maxder/alpine-hiawatha:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk -U --no-progress add \
	curl \
	php7-mcrypt \
	php7-openssl \
	php7-pspell \
	php7-dom \
	php7-bcmath \
	php7-odbc \
	php7-zip \
	php7-zlib \
	php7-calendar \
	php7-gd \
	php7-ldap \
	php7-json \
	php7-pdo_dblib \
	php7-phpdbg \
	php7-gettext \
	php7-dba \
	php7-xmlrpc \
	php7-pcntl \
	php7-phar \
	php7-bz2 \
	php7-ctype \
	php7-cgi \
	php7-imap \
	php7-xsl \
	php7-mysqlnd \
	php7-pear \
	php7-mbstring \
	php7-sqlite3 \
	php7-pdo_pgsql \
	php7-pdo_odbc \
	php7-pdo_mysql \
	php7-opcache \
	php7-soap \
	php7-fpm \
	php7-xmlreader \
	php7-exif \
	php7-xml \
	php7-mysqli \
	php7-pgsql \
	php7-curl \
	php7-ftp \
	php7-common \
	php7-intl \
	php7-pdo \
	php7-iconv \
	php7-pdo_sqlite

## Small fixes
RUN ln -s /etc/php7 /etc/php \
 && ln -s /usr/bin/php7 /usr/bin/php \
 && ln -s /usr/sbin/php-fpm7 /usr/bin/php-fpm \
 && ln -s /usr/sbin/php-cgi7 /usr/sbin/php-cgi \
 && ln -s /usr/lib/php7 /usr/lib/php

RUN addgroup hiawatha www-data \
 && sed -i "s*user = nobody*user = hiawatha*g" /etc/php/php-fpm.conf \
 && sed -i "s*group = nobody*group = www-data*g" /etc/php/php-fpm.conf \
 && echo "clear_env = no" >> /etc/php/php-fpm.conf

## PHP config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 2G/g" /etc/php/php.ini \
 && sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 2G/g" /etc/php/php.ini \
 && sed -i -e "s/short_open_tag\s*=\s*Off/short_open_tag = On/g" /etc/php/php.ini \
 && sed -i -e "s/always_populate_raw_post_data\s*=\s*On/always_populate_raw_post_data = -1/g" /etc/php/php.ini

# Install composer global bin
RUN curl -sS https://getcomposer.org/installer | php \
 && mv composer.phar /usr/local/bin/composer

#RUN echo "apc.shm_size = 128M" >> /etc/php7/conf.d/00-apcu.ini \
# && echo "apc.ttl=7200" >> /etc/php7/conf.d/00-apcu.ini \
# && echo "apc.user_ttl=7200" >> /etc/php7/conf.d/00-apcu.ini \
# && echo "apc.gc_ttl=3600" >> /etc/php7/conf.d/00-apcu.ini

ADD service /etc/service
RUN chmod +x /etc/service/*/*

RUN sed -i "s*\# DEFAULT WEBSITE*FastCGIserver \{\n        FastCGIid = PHP5\n        ConnectTo = 127.0.0.1:9000\n        Extension = php\n        SessionTimeout = 600\n\}\n\n\# DEFAULT WEBSITE*g" /etc/hiawatha/hiawatha.conf \
 && sed -i "s*\#CGIhandler = /usr/bin/php-cgi:php*CGIhandler = /usr/bin/php-cgi:php*g" /etc/hiawatha/hiawatha.conf \
 && sed -i "s*/var/log/hiawatha/error.log*/var/log/hiawatha/error.log \nExecuteCGI = yes\n*g" /etc/hiawatha/hiawatha.conf \
 && sed -i "s#/var/log/hiawatha/error.log#/var/log/hiawatha/error.log\n\#ReverseProxy ^/.* http://www.example.com:80/#g" /etc/hiawatha/hiawatha.conf
RUN touch /_firstrun

EXPOSE 80 443
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
