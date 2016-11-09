FROM maxder/debian-apache-php:ARCHTAG
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
        php7.0-memcached \
        php7.0-redis \
        php7.0-mbstring \
        php7.0-soap \
        php-mongodb \
        php7.0-opcache \
	tinymce \
	ttf-bitstream-vera \
	ttf-freefont \
	openssl \
	mariadb-client

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
