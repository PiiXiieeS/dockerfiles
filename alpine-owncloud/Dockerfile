FROM maxder/PLACEHOLDER-base:edge
MAINTAINER Christian-Maximilian Steier

ENV OWNCLOUD_VERSION 8.2
ENV OWNCLOUD_RELEASE 1

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --update-cache \
    nginx \
    file \
    php \
    php-gd \
    php-xml \
    php-cgi \
    php-pdo_pgsql \
    php-soap \
    php-gettext \
    php-fpm \
    php-curl \
    php-mcrypt \
    php-json \
    php-intl \
    php-imap \
    php-opcache \
    php-apcu \
    php-pear \
    php-xmlrpc \
    php-cli \
    php-pdo \
    php-zip \
    php-dom \
    php-ctype \
    php-zlib \
    php-iconv \
    php-posix \
    php-openssl \
    php-ftp \
    perl-xml-simple \
    perl-xml-writer@testing \
    memcached \
    libmemcached \
    imagemagick \
    samba-client \
    bzip2 \
    graphviz \
    ffmpeg \
    php-pdo_mysql \
    php-mysql \
    php-mysqli \
    mysql-client \
    pwgen

ADD service /etc/service
RUN chmod +x /etc/service/*/*
ADD conf/nginx.conf /etc/nginx/nginx.conf

RUN addgroup nginx www-data \
 && sed -i "s*user = nobody*user = nginx*g" /etc/php/php-fpm.conf \
 && sed -i "s*group = nobody*group = www-data*g" /etc/php/php-fpm.conf

## PHP config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 512M/g" /etc/php/php.ini \
 && sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 512M/g" /etc/php/php.ini \
 && sed -i -e "s/short_open_tag\s*=\s*Off/short_open_tag = On/g" /etc/php/php.ini

## Fixes: PHP is configured to populate raw post data. Since PHP 5.6 this will lead to PHP throwing notices for perfectly valid code. #19
RUN echo 'always_populate_raw_post_data = -1' >> /etc/php/php.ini 

RUN cat /etc/php/php.ini

ADD https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.${OWNCLOUD_RELEASE}.tar.bz2 /tmp/oc.tar.bz2
RUN tar xfvj /tmp/oc.tar.bz2 -C /usr/share/nginx/html/ \
 && chown -R nginx:www-data /usr/share/nginx/html/owncloud \
 && mkdir /data \
 && chown -R nginx:www-data /data \
 && echo "*/15  *  *  *  * php -f /usr/share/nginx/html/owncloud/cron.php" >> /etc/crontab
ADD conf/autoconfig.php /autoconfig.php

RUN rm -rf /var/cache/apk/*  /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp

EXPOSE 80 443
RUN touch /firstrun

ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
