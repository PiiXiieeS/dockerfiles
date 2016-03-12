FROM maxder/PLACEHOLDER-nginx:edge
MAINTAINER Christian-Maxilian Steier

RUN apk -U --no-cache --no-progress add \
	php-apcu \
	php-bcmath \
	php-bz2 \
        php-cgi \
        php-common \
        php-ctype \
	php-curl \
	php-dom \
	php-exif \
	php-fpm \
	php-ftp \
        php-gd \
        php-gettext \
        php-gmp \
	php-imap \
	php-iconv \
        php-json \
	php-ldap \
        php-mcrypt \
        php-memcache \
	php-mssql \
	php-mysqli \
	php-opcache \
        php-openssl \
        php-odbc \
	php-pdo \
	php-pdo_dblib \
	php-pdo_odbc \
        php-pdo_sqlite \
        php-pdo_mysql \
	php-posix \
	php-soap \
        php-sqlite3 \
	php-xml \
	php-xmlreader \
	php-xmlrpc \
        php-zlib \
        php-zip

RUN addgroup nginx www-data \
 && sed -i "s*user = nobody*user = nginx*g" /etc/php/php-fpm.conf \
 && sed -i "s*group = nobody*group = www-data*g" /etc/php/php-fpm.conf \
 && echo "clear_env = no" >> /etc/php/php-fpm.conf

## PHP config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 512M/g" /etc/php/php.ini \
 && sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 512M/g" /etc/php/php.ini \
 && sed -i -e "s/short_open_tag\s*=\s*Off/short_open_tag = On/g" /etc/php/php.ini

RUN echo "apc.shm_size = 128M" >> /etc/php/conf.d/apcu.ini \
 && echo "apc.ttl=7200" >> /etc/php/conf.d/apcu.ini \
 && echo "apc.user_ttl=7200" >> /etc/php/conf.d/apcu.ini \
 && echo "apc.gc_ttl=3600" >> /etc/php/conf.d/apcu.ini

ADD service /etc/service
RUN chmod +x /etc/service/*/*
ADD conf/apachemod.conf /etc/nginx/conf.d/apachemod.conf
ADD conf/fpm.conf /etc/nginx/conf.d/fpm.conf

EXPOSE 9000
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
