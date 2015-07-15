FROM eboraas/debootstrap:minbase-jessie
MAINTAINER Christian-Maxilian Steier
ENV HIAWATHA_VERSION 9.13
#ENV VIRTUAL_HOST domain.org

ADD http://http.debian.net/debian/project/trace/ftp-master.debian.org /etc/trace_ftp-master.debian.org
ADD http://security.debian.org/project/trace/security-master.debian.org /etc/trace_security-master.debian.org

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl
# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Set timezone
RUN echo "Europe/Berlin" > /etc/timezone \ 
 && dpkg-reconfigure -f noninteractive tzdata

# Install basics
RUN apt-get update
RUN apt-get install  -y \ 
 vim \
 supervisor \ 
 wget \
 logrotate \
 unzip \
 php5-cgi \
 php5 \
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
 php5-snmp \
 php5-sqlite \
 php5-tidy \
 php5-xmlrpc \ 
 php5-xsl \
 php5-xcache \
 apache2-utils \ 
 php5-fpm

RUN echo "deb http://repo.suhosin.org/ debian-jessie main" >> /etc/apt/sources.list \
 && wget https://sektioneins.de/files/repository.asc \
 && apt-key add repository.asc
RUN apt-get update \
 && apt-get install php5-suhosin-extension

# Configure PHP-FPM
RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini && \
	sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini && \
	sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php5/fpm/php.ini && \
	sed -i "s/;date.timezone.*/date.timezone = Europe\/Berlin/" /etc/php5/fpm/php.ini && \
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

# Hiawatha
RUN cd /tmp \
 && wget http://files.tuxhelp.org/hiawatha/hiawatha_${HIAWATHA_VERSION}_amd64.deb \
 && dpkg -i *.deb \
 && rm *.deb
RUN sed -i "s*zlib.output_compression = Off*zlib.output_compression = On*g" /etc/php5/fpm/php.ini \
 && sed -i "s*zlib.output_compression_level = 1*zlib.output_compression_level = 6*g" /etc/php5/fpm/php.ini
RUN echo "\n\n[www] \nuser = www-data \ngroup = www-data \nlisten.mode = 0666 \nlisten = /var/run/php5-fpm.sock \npm = static \npm.max_children = 100 \nchdir = / \n\n" >> /etc/php5/fpm/php-fpm.conf
ADD conf/hiawatha.conf /etc/hiawatha/hiawatha.conf
RUN sed -i ':a;N;$!ba;s/\n/WILDCARD/g' /var/www/hiawatha/index.html \
 && sed -i "s*</div>WILDCARD</body*<h2>Viewing your PHP Settings</h2><p>You can now access phpinfo page under <a href='http://DOMAIN/phpinfo/'>/phpinfo</a>.</p></div>WILDCARD</body*g" /var/www/hiawatha/index.html \
 && sed -i "s*WILDCARD*\n*g" /var/www/hiawatha/index.html 

# Clean up APT when done.
RUN apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD scripts/start.sh /start.sh
ADD scripts/start-phpfpm.sh /start-phpfpm.sh
ADD scripts/run.sh /run.sh
RUN chmod 755 /*.sh
ADD conf/supervisord-hiawatha.conf /etc/supervisor/conf.d/supervisord-hiawatha.conf
ADD conf/supervisord-php.conf /etc/supervisor/conf.d/supervisord-php.conf
RUN mkdir /var/www/phpinfo
ADD conf/phpinfo.php /var/www/phpinfo/index.php
RUN chown www-data:www-data -R /var/www/phpinfo

EXPOSE 80
CMD ["/run.sh"]
