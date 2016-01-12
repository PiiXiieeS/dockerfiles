FROM maxder/PLACEHOLDER-base:edge
MAINTAINER Christian-Maximilian Steier

ENV HUMHUB_VERSION 1.0.0
ENV BETA_RELEASE 3

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --update-cache \
    nginx \
    file \
    php \
    php-exif \
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
    bzip2 \
    graphviz \
    sqlite \
    php-ldap \
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
 && sed -i "s*group = nobody*group = www-data*g" /etc/php/php-fpm.conf \
 && echo "clear_env = no" >> /etc/php/php-fpm.conf

## PHP config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 512M/g" /etc/php/php.ini \
 && sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 512M/g" /etc/php/php.ini \
 && sed -i -e "s/short_open_tag\s*=\s*Off/short_open_tag = On/g" /etc/php/php.ini

## Fixes: PHP is configured to populate raw post data. Since PHP 5.6 this will lead to PHP throwing notices for perfectly valid code. #19
RUN echo 'always_populate_raw_post_data = -1' >> /etc/php/php.ini

RUN echo "apc.shm_size = 128M" >> /etc/php/conf.d/apcu.ini \
 && echo "apc.ttl=7200" >> /etc/php/conf.d/apcu.ini \
 && echo "apc.user_ttl=7200" >> /etc/php/conf.d/apcu.ini \
 && echo "apc.gc_ttl=3600" >> /etc/php/conf.d/apcu.ini

ENV humhubpath /usr/share/nginx/html/humhub
ADD http://downloads.sourceforge.net/project/humhub/humhub-${HUMHUB_VERSION}-beta.${BETA_RELEASE}.tar.gz /tmp/humhub.tar.gz
RUN tar xzf /tmp/humhub.tar.gz -C /usr/share/nginx/html/ \
 && mv /usr/share/nginx/html/humhub-${HUMHUB_VERSION}-beta.${BETA_RELEASE} ${humhubpath} \
 && find ${humhubpath}/ -type f -print0 | xargs -0 chmod 0640 \
 && find ${humhubpath}/ -type d -print0 | xargs -0 chmod 0750 \
 && chown -R root:www-data ${humhubpath}/

RUN rm -rf /var/cache/apk/*  /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp

EXPOSE 80 443
RUN touch /firstrun

ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
