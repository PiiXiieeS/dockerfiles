FROM maxder/alpine-hiawatha:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apk -U --no-progress add \
	php-apcu \
	php-bcmath \
	php-bz2 \
        php-cgi \
        php-cli \
        php-common \
        php-ctype \
	php-curl \
	php-dom \
	php-exif \
	php-fpm \
	php-ftp \
        php-gd \
        php-gettext \
        php-gmp \
	php-imap \
	php-iconv \
	php-intl \
        php-json \
	php-ldap \
        php-mcrypt \
        php-memcache \
	php-mssql \
	php-mysqli \
	php-opcache \
        php-openssl \
        php-odbc \
	php-pdo \
	php-pdo_dblib \
	php-pdo_odbc \
        php-pdo_sqlite \
        php-pdo_mysql \
        php-pear \
        php-phar \
	php-posix \
	php-soap \
        php-sqlite3 \
	php-xml \
	php-xmlreader \
	php-xmlrpc \
        php-zlib \
        php-zip

## PHP config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 2G/g" /etc/php/php.ini \
 && sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 2G/g" /etc/php/php.ini \
 && sed -i -e "s/short_open_tag\s*=\s*Off/short_open_tag = On/g" /etc/php/php.ini \
 && sed -i "s*\;env\[PATH\]*env\[PATH\]*g" /etc/php/php-fpm.conf 

RUN echo "apc.shm_size = 128M" >> /etc/php/conf.d/apcu.ini \
 && echo "apc.ttl=7200" >> /etc/php/conf.d/apcu.ini \
 && echo "apc.user_ttl=7200" >> /etc/php/conf.d/apcu.ini \
 && echo "apc.gc_ttl=3600" >> /etc/php/conf.d/apcu.ini

ADD service /etc/service
RUN chmod +x /etc/service/*/*

RUN sed -i "s*\# DEFAULT WEBSITE*FastCGIserver \{\n        FastCGIid = PHP5\n        ConnectTo = 127.0.0.1:9000\n        Extension = php\n        SessionTimeout = 600\n\}\n\n\# DEFAULT WEBSITE*g" /etc/hiawatha/hiawatha.conf \
 && sed -i "s*\#CGIhandler = /usr/bin/php-cgi:php*CGIhandler = /usr/bin/php-cgi:php*g" /etc/hiawatha/hiawatha.conf \
 && sed -i "s*/var/log/hiawatha/error.log*/var/log/hiawatha/error.log \nExecuteCGI = yes\n*g" /etc/hiawatha/hiawatha.conf \
 && sed -i "s#/var/log/hiawatha/error.log#/var/log/hiawatha/error.log\n\#ReverseProxy ^/.* http://www.example.com:80/#g" /etc/hiawatha/hiawatha.conf \
 && if [ ! -d "/etc/hiawatha/sites-available" ]; then mkdir /etc/hiawatha/sites-available ;fi \
 && echo -e "VirtualHost {\n        Hostname = localhost\n        WebsiteRoot = /usr/share/webapps\n        #TLScertFile = ssl/localhost.localdomain.pem\n	StartFile = index.php\n        UseFastCGI = PHP5\n        PreventSQLi = yes\n        PreventXSS = yes\n#       RequireSSL = yes\n}" > /etc/hiawatha/sites-available/localhost.conf \
 && if [ ! -d "/usr/share/webapps" ]; then mkdir /usr/share/webapps ;fi
RUN touch /firstrun

EXPOSE 80 443
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
