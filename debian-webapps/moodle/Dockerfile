FROM maxder/debian-nginx-php:x86_64
MAINTAINER Christian-Maxilian Steier

ENV MOODLE_VERSION 31

# Basic Requirements
RUN apt-get update \ 
 && apt-get -y install \ 
	pwgen \
	python-setuptools \
	curl \
	wget \
	git \
	unzip \
	inotify-tools

# Moodle Requirements
RUN apt-get -y install \
	libjs-jquery \
	perl \
	memcached \
	tinymce \
	ttf-bitstream-vera \
	ttf-freefont \
	mariadb-client

## Set max pload to 2 GB
#RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 2G/g" /etc/php/php.ini \
# && sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 2G/g" /etc/php/php.ini

# Moodle
ADD https://download.moodle.org/download.php/direct/stable${MOODLE_VERSION}/moodle-latest-${MOODLE_VERSION}.tgz /tmp/moodle-latest-${MOODLE_VERSION}.tgz
RUN cd /tmp \
 && export appdir="/usr/share/webapps/moodle" \
 && if [ ! -d "/usr/share/webapps" ]; then mkdir /usr/share/webapps ;fi \
 && tar zxvf moodle-latest-${MOODLE_VERSION}.tgz -C /usr/share/webapps/ \
 && chown -R www-data:www-data $appdir \
 && mkdir /var/moodledata \
 && chown -R www-data:www-data /var/moodledata
RUN echo "* * * * * www-data php $appdir/admin/cli/cron.php >/dev/null" >> /etc/crontab
RUN usermod -c "Moodle" www-data
ADD conf/nginx_moodle.site /etc/nginx/moodle.site

# Moosh by Tomasz Muras
WORKDIR /opt
RUN git clone git://github.com/tmuras/moosh.git \
 && cd moosh \
 && composer install \
 && ln -s $PWD/moosh.php /bin/moosh

ADD service /etc/service
RUN chmod +x /etc/service/*/* \
 && touch /__firstrun

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /tmp/*

WORKDIR /usr/share/webapps/moodle
VOLUME ["/usr/share/webapps/moodle", "/var/moodledata"]

EXPOSE 80/tcp 443/tcp
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
