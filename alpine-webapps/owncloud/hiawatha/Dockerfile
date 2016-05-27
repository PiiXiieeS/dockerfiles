FROM maxder/alpine-hiawatha-php:ARCHTAG
MAINTAINER Christian-Maximilian Steier

ENV OWNCLOUD_VERSION 9.0
ENV OWNCLOUD_RELEASE 2

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk -U --no-progress add \
    file \
    libintl \
    perl-xml-simple \
    perl-xml-writer@testing \
    phpredis@testing \
    php-memcached@testing \
    memcached \
    libmemcached \
    imagemagick \
    bzip2 \
    graphviz \
    ffmpeg \
    mariadb-client \
    pwgen \
    sudo

ADD service /etc/service
RUN chmod +x /etc/service/*/*

RUN touch /etc/php/conf.d/redis.ini \
 && echo extension=redis.so > /etc/php/conf.d/redis.ini
RUN rm /etc/hiawatha/localhost.site
ADD conf/owncloud.site /etc/hiawatha/owncloud.site

ENV ocpath /usr/share/webapps/owncloud
ADD https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.${OWNCLOUD_RELEASE}.tar.bz2 /tmp/oc.tar.bz2
RUN mkdir -p /usr/share/webapps \
 && tar xfvj /tmp/oc.tar.bz2 -C /usr/share/webapps/ \
 && find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640 \
 && find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750 \
 && chown -R root ${ocpath}/ \
 && chown -R root:nobody ${ocpath}/apps/ \
 && chown -R root:nobody ${ocpath}/config/ \
 && chown -R root:nobody ${ocpath}/themes/ \
 && chown root:nobody ${ocpath}/.htaccess \
 && chmod 0644 ${ocpath}/.htaccess
RUN echo -e "#!/bin/sh \n\nsudo -u nobody php /usr/share/webapps/owncloud/cron.php" > /etc/periodic/15min/owncloud \
 && chmod +x /etc/periodic/15min/owncloud
ADD conf/autoconfig.php /autoconfig.php

RUN rm -rf /var/cache/apk/*  /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp /tmp/*
RUN touch /__firstrun

EXPOSE 80 443
VOLUME ["/var/owncloud"]
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
