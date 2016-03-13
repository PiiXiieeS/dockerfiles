FROM maxder/PLACEHOLDER-php-fpm:edge
MAINTAINER Christian-Maximilian Steier

ENV HUMHUB_VERSION 1.0.0
ENV BETA_RELEASE 4

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk -U --no-cache --no-progress add \
    file \
    perl-xml-simple \
    perl-xml-writer@testing \
    memcached \
    libmemcached \
    imagemagick \
    bzip2 \
    graphviz \
    sqlite \
    mysql-client \
    pwgen

ADD service /etc/service
RUN chmod +x /etc/service/*/*

ENV humhubpath /usr/share/webapps/humhub
ADD http://downloads.sourceforge.net/project/humhub/humhub-${HUMHUB_VERSION}-beta.${BETA_RELEASE}.tar.gz /tmp/humhub.tar.gz
RUN if [ ! -d "/usr/share/webapps" ]; then mkdir /usr/share/webapps ; fi \ 
 && tar xzf /tmp/humhub.tar.gz -C /usr/share/webapps/ \
 && mv /usr/share/webapps/humhub-${HUMHUB_VERSION}-beta.${BETA_RELEASE} ${humhubpath} \
 && find ${humhubpath}/ -type f -print0 | xargs -0 chmod 0640 \
 && find ${humhubpath}/ -type d -print0 | xargs -0 chmod 0750 \
 && chown -R root:www-data ${humhubpath}/ \
 && echo -e "#!/bin/sh \n\n/usr/share/webapps/PLACEHOLDER/protected/yii cron/hourly" > /etc/periodic/15min/humhub \
 && chmod +x /etc/periodic/15min/humhub \
 && echo -e "#!/bin/sh \n\n/usr/share/webapps/PLACEHOLDER/protected/yii cron/daily" > /etc/periodic/daily/humhub \
 && chmod +x /etc/periodic/daily/humhub
ADD conf/nginx_humhub.conf /etc/nginx/conf.d/localhost.conf 

RUN rm -rf /var/cache/apk/*  /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp

EXPOSE 80 443
RUN touch /firstrun

ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
