FROM maxder/debianbase
MAINTAINER Christian-Maxilian Steier
ENV HIAWATHA_VERSION 9.14

RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    wget \
    php5 \
    php5-cgi \
    php5-cli \ 
    php5-mysqlnd \
    php5-curl \
    php5-gd \
    php5-intl \ 
    php-pear \
    php5-imagick \ 
    php5-imap \
    php5-mcrypt \ 
    php5-memcache \  
    php5-pspell \
    php5-recode \
    php5-sqlite \
    php5-tidy \
    php5-xmlrpc \ 
    php5-xsl \
    php5-apcu \
    apache2-utils \ 
    php5-fpm

# Set timezone
#RUN echo "Europe/Berlin" > /etc/timezone \ 
# && dpkg-reconfigure -f noninteractive tzdata

RUN echo "deb http://repo.suhosin.org/ debian-jessie main" >> /etc/apt/sources.list \
 && wget https://sektioneins.de/files/repository.asc \
 && apt-key add repository.asc
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y php5-suhosin-extension

# Configure PHP-FPM
RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini && \
	sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini && \
	sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php5/fpm/php.ini && \
	sed -i "s/max_execution_time = .*/max_execution_time = 300/" /etc/php5/fpm/php.ini && \
	sed -i "s/max_input_time = .*/max_input_time = 300/" /etc/php5/fpm/php.ini && \
	sed -i "s/post_max_size = .*/post_max_size = 512M/" /etc/php5/fpm/php.ini && \
	sed -i "s/upload_max_filesize = .*/upload_max_filesize = 512M/" /etc/php5/fpm/php.ini && \
	sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini && \
	sed -i "s/short_open_tag = .*/short_open_tag = On/" /etc/php5/fpm/php.ini && \
	echo "xdebug.max_nesting_level = 1000" >> /etc/php5/fpm/conf.d/20-xdebug.ini && \
	echo "xdebug.remote_enable = 1" >> /etc/php5/fpm/conf.d/20-xdebug.ini && \
	echo "xdebug.remote_connect_back = 1" >> /etc/php5/fpm/conf.d/20-xdebug.ini && \
	echo "xdebug.remote_port = 9000" >> /etc/php5/fpm/conf.d/20-xdebug.ini
RUN sed -i "s/;daemonize = .*/daemonize = no/" /etc/php5/fpm/php-fpm.conf
RUN sed -i "s/user =.*/user = root/" /etc/php5/fpm/pool.d/www.conf && \
	sed -i "s/group =.*/group = root/" /etc/php5/fpm/pool.d/www.conf && \
	sed -i "s/listen\.owner.*/listen.owner = root/" /etc/php5/fpm/pool.d/www.conf && \
	sed -i "s/;listen\.group.*/listen.group = root/" /etc/php5/fpm/pool.d/www.conf && \
	sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php5/fpm/pool.d/www.conf && \
	sed -i "s/listen =.*/listen = 0.0.0.0:9000/" /etc/php5/fpm/pool.d/www.conf
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/fpm/php.ini
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5/cli/php.ini

# Hiawatha
RUN cd /tmp \
 && wget http://files.tuxhelp.org/hiawatha/hiawatha_${HIAWATHA_VERSION}_amd64.deb \
 && dpkg -i *.deb \
 && rm *.deb
RUN sed -i "s*zlib.output_compression = Off*zlib.output_compression = On*g" /etc/php5/fpm/php.ini \
 && sed -i "s*zlib.output_compression_level = 1*zlib.output_compression_level = 6*g" /etc/php5/fpm/php.ini
RUN echo "\n\n[www] \nuser = www-data \ngroup = www-data \nlisten.mode = 0666 \nlisten = /var/run/php5-fpm.sock \npm = static \npm.max_children = 100 \nchdir = / \n\n" >> /etc/php5/fpm/php-fpm.conf
ADD conf/hiawatha.conf /etc/hiawatha/hiawatha.conf

RUN mkdir           /etc/service/phpfpm
ADD service/phpfpm.sh /etc/service/phpfpm/run
RUN chmod +x        /etc/service/phpfpm/run
RUN mkdir           /etc/service/hiawatha
ADD service/hiawatha.sh /etc/service/hiawatha/run
RUN chmod +x        /etc/service/hiawatha/run
RUN touch /firstrun
ADD scripts/firstrun.sh /etc/my_init.d/firstrun.sh
RUN chmod +x /etc/my_init.d/firstrun.sh

# Clean up APT when done.
RUN apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
