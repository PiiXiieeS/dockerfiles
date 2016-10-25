FROM maxder/debian-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ENV COMPOSER_VERSION 1.2.1

RUN apt-get update \
 && apt-get install -y \
	apt-transport-https \
	php7.0-apcu \
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
	php7.0-zip \
	aspell-de

## Small fixes
RUN ln -s /usr/sbin/php-fpm7.0 /usr/bin/php-fpm
# fix ownership of sock file for php-fpm
RUN sed -i -e "s*;listen.mode = 0660*listen.mode = 0750*g" /etc/php/7.0/fpm/pool.d/www.conf && \
find /etc/php/7.0/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

## PHP config
RUN sed -i -e "s*short_open_tag = Off*short_open_tag = On*g" /etc/php/7.0/fpm/php.ini \
 && sed -i -e "s*;always_populate_raw_post_data = -1*always_populate_raw_post_data = -1*g" /etc/php/7.0/fpm/php.ini

RUN echo "apc.shm_size = 128M" >> /etc/php/7.0/mods-available/apcu.ini \
&& echo "apc.ttl=7200" >> /etc/php/7.0/mods-available/apcu.ini \
&& echo "apc.user_ttl=7200" >> /etc/php/7.0/mods-available/apcu.ini \
&& echo "apc.gc_ttl=3600" >> /etc/php/7.0/mods-available/apcu.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
 && chmod +x /usr/local/bin/composer

RUN touch /firstrun
COPY rootfs /
EXPOSE 80/tcp 443/tcp
