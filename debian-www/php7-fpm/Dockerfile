FROM maxder/debian-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ENV COMPOSER_VERSION 1.1.2

RUN echo 'deb http://packages.dotdeb.org jessie all' > /etc/apt/sources.list.d/dotdeb.list \
 && apt-get update \
 && apt-get install -y apt-transport-https \
 && curl http://www.dotdeb.org/dotdeb.gpg | apt-key add -

RUN apt-get update \
 && apt-get install -y \
	php7.0-apcu \
	php7.0-apcu-bc \
	php7.0-bz2 \
	php7.0-cgi \
	php7.0-cli \
	php7.0-common \
	php7.0-curl \
	php7.0-fpm \
	php7.0-gd \
	php7.0-geoip \
	php7.0-gmp \
	php7.0-imagick \
	php7.0-imap \
	php7.0-intl \
	php7.0-json \
	php7.0-ldap \
	php7.0-mcrypt \
	php7.0-memcached \
	php7.0-mongodb \
	php7.0-mysql \
	php7.0-odbc \
	php7.0-opcache \
	php7.0-pgsql \
	php7.0-pspell \
	php7.0-readline \
	php7.0-recode \
	php7.0-redis \
	php7.0-sqlite3 \
	php7.0-xmlrpc \
	php7.0-xsl \
	aspell-de

ADD conf/fpm.conf /fpm.conf
RUN ln -s /usr/sbin/php-fpm7.0 /usr/bin/php-fpm \
 && mkdir /run/php
# fix ownership of sock file for php-fpm
RUN sed -i -e "s*;listen.mode = 0660*listen.mode = 0750*g" /etc/php/7.0/fpm/pool.d/www.conf && \
find /etc/php/7.0/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
 && chmod +x /usr/local/bin/composer

ADD service/php-fpm /etc/service/php-fpm
RUN chmod +x /etc/service/*/*
RUN touch /_firstrun

EXPOSE 80/tcp 443/tcp
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
