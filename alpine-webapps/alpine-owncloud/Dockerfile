FROM maxder/alpine-php-fpm:ARCHTAG
MAINTAINER Christian-Maximilian Steier

ENV OWNCLOUD_VERSION 9.0
ENV OWNCLOUD_RELEASE 1

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk -U add \
    file \
    libcrypto1.0 \
    libintl \
    perl-xml-simple \
    perl-xml-writer@testing \
    phpredis@testing \
    libxml2 \
    php-memcached@testing \
    memcached \
    libmemcached \
    imagemagick \
    bzip2 \
    graphviz \
    ffmpeg \
    mysql-client \
    pwgen \
    sudo

ADD service /etc/service
RUN chmod +x /etc/service/*/*

RUN touch /etc/php/conf.d/redis.ini \
 && echo extension=redis.so > /etc/php/conf.d/redis.ini
ADD conf/nginx-owncloud.conf /etc/nginx/sites-available/localhost.conf

ENV ocpath /usr/share/webapps/owncloud
ADD https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.${OWNCLOUD_RELEASE}.tar.bz2 /tmp/oc.tar.bz2
RUN mkdir -p /usr/share/webapps \
 && tar xfvj /tmp/oc.tar.bz2 -C /usr/share/webapps/ \
 && find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640 \
 && find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750 \
 && chown -R root:www-data ${ocpath}/ \
 && chown -R nginx:www-data ${ocpath}/apps/ \
 && chown -R nginx:www-data ${ocpath}/config/ \
 && chown -R nginx:www-data ${ocpath}/themes/ \
 && chown root:www-data ${ocpath}/.htaccess \
 && chmod 0644 ${ocpath}/.htaccess
RUN echo -e "#!/bin/sh \n\nsudo -u nginx php /usr/share/webapps/owncloud/cron.php" > /etc/periodic/15min/owncloud \
 && chmod +x /etc/periodic/15min/owncloud
ADD conf/autoconfig.php /autoconfig.php

RUN rm -rf /var/cache/apk/*  /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp

EXPOSE 80 443
RUN touch /firstrun

VOLUME ["/var/owncloud"]
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
