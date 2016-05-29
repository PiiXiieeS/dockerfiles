FROM maxder/alpine-nginx-php:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ENV MAHARA_VERSION 16.04
ENV MAHARA_RELEASE 0

RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk -U add \
	fcgi \
	file \
	php-memcached@testing \
    	memcached \
    	libmemcached \
    	imagemagick \
    	bzip2 \
	graphviz \
   	mysql-client \
    	pwgen \
	sudo

ADD service /etc/service
RUN chmod +x /etc/service/*/*

ADD conf/nginx-mahara.conf  /etc/nginx/sites-enabled/localhost.site
ADD conf/apachemod.conf /etc/nginx/apachemod.conf

## Mahara
ADD https://launchpad.net/mahara/${MAHARA_VERSION}/${MAHARA_VERSION}.${MAHARA_RELEASE}/+download/mahara-${MAHARA_VERSION}.${MAHARA_RELEASE}.tar.gz /tmp/mahara.tar.gz
ENV maharapath /usr/share/webapps/mahara
RUN if [ ! -d "/usr/share/webapps" ]; then mkdir -p /usr/share/webapps ; fi \
 && tar -xvzf /tmp/mahara.tar.gz mahara-${MAHARA_VERSION}.${MAHARA_RELEASE}/htdocs -C /usr/share/webapps/ \
 && mv /usr/share/webapps/mahara-${MAHARA_VERSION}.${MAHARA_RELEASE}/htdocs ${maharapath} \
 && rm -r /usr/share/webapps/mahara-${MAHARA_VERSION}.${MAHARA_RELEASE} \
 && find ${maharapath}/ -type f -exec chmod 644 {} \; \
 && find ${maharapath}/ -type d -exec chmod 750 {} \; \
 && chown -R nginx:www-data ${maharapath} \
 && mkdir -p /var/mahara/data \
 && chown nginx:www-data /var/mahara/data \
 && chmod 775 /var/mahara/data \
 && touch /var/log/mahara_cron.log \
 && chown -R nginx:www-data /var/log/mahara_cron.log \
 && echo -e "#!/bin/sh \n\nsudo -u nginx php ${maharapath}/lib/cron.php >> /var/log/mahara_cron.log 2>&1" > /etc/periodic/15min/mahara \
 && chmod +x /etc/periodic/15min/mahara \
 && sed -i "s*5.0.25*05.0.25*g" ${maharapath}/init.php

RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp /tmp/*
RUN touch /firstrun

EXPOSE 80
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
