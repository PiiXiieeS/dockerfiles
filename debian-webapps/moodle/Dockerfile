FROM maxder/debian-nginx-php:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ENV VERSION 31

# Basic Requirements
RUN apt-get update \ 
 && apt-get -y install \ 
	pwgen \
	python-setuptools \
	curl \
	wget \
	git \
	unzip \
	netcat \
	inotify-tools

# Moodle Requirements
RUN apt-get -y install \
	libjs-jquery \
	perl \
	memcached \
	php7.0-redis \
	tinymce \
	ttf-bitstream-vera \
	ttf-freefont \
	mariadb-client

## Set max pload to 2 GB
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 2G/g" /etc/php/7.0/fpm/php.ini \
 && sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 2G/g" /etc/php/7.0/fpm/php.ini

# Moodle
WORKDIR /usr/share/webapps
ADD https://download.moodle.org/download.php/direct/stable${VERSION}/moodle-latest-${VERSION}.tgz moodle.tgz
RUN export APPDIR="/usr/share/webapps/moodle" \
 && tar zxvf moodle.tgz \
 && rm moodle.tgz \
 && mkdir $APPDIR/config \
 && touch $APPDIR/config/config.php \
 && ln -s $APPDIR/config/config.php $appdir/config.php \
 && ln -s $APPDIR/lib $APPDIR/config/lib \
 && chown -R www-data:www-data $APPDIR \
 && mkdir /var/moodledata \
 && chown -R www-data:www-data /var/moodledata

# Redis
WORKDIR /usr/share/webapps/moodle/local
ADD https://github.com/moodlerooms/moodle-local_redislock/archive/master.zip moodle-local_redislock.zip
RUN unzip moodle-local_redislock.zip \
 && mv moodle-local_redislock-master redislock \
 && chown -R www-data:www-data redislock \
 && rm moodle-local_redislock.zip

RUN echo -e "*/15 * * * * www-data php $APPDIR/admin/cli/cron.php >/dev/null\n" >> /etc/crontab \
 && usermod -c "Moodle" www-data

# Moosh by Tomasz Muras
WORKDIR /opt
RUN git clone git://github.com/tmuras/moosh.git \
 && cd moosh \
 && composer install \
 && ln -s $PWD/moosh.php /bin/moosh

COPY rootfs /

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /tmp/*

WORKDIR /usr/share/webapps/moodle
VOLUME ["/usr/share/webapps/moodle", "/var/moodledata"]

EXPOSE 80/tcp 443/tcp
