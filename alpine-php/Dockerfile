FROM maxder/PLACEHOLDER-base:edge
MAINTAINER Christian-Maxilian Steier

RUN echo "@maxder https://github.com/christiansteier/alpine-repo/raw/master" >> /etc/apk/repositories
RUN apk -U add --allow-untrusted \
	php@maxder \
	php-common@maxder \
	php-cli@maxder \
	php-fpm@maxder \
	php-json@maxder \ 
	php-zlib@maxder \
	php-xml@maxder \
	php-pdo@maxder \
	php-phar@maxder \
	php-openssl@maxder \
	php-pdo@maxder \
	php-pdo_mysql@maxder \
	php-mysqli@maxder \
	php-gd@maxder \
	php-iconv@maxder \
	php-mcrypt@maxder \
	php-curl@maxder \
	php-opcache@maxder \
	php-ctype@maxder \
	php-intl@maxder \
	php-bcmath@maxder \
	php-dom@maxder \
	php-xmlreader@maxder \
	php-cgi@maxder \
	php-pdo_pgsql@maxder \
	php-soap@maxder \
    	php-gettext@maxder \
	php-json@maxder \
	php-xmlrpc@maxder \
	php-posix@maxder \
	php-ftp@maxder \
	php-zip@maxder
	
RUN sed -i "s*include=/etc/php/php-fpm.d*;include=/etc/php/php-fpm.d*g" /etc/php/php-fpm.conf \
 && echo -e "[www] \n user = nobody \n group = nobody \n listen = 127.0.0.1:9000 \n pm = dynamic \n pm.max_children = 5 \n pm.start_servers = 2 \n pm.min_spare_servers = 1 \n pm.max_spare_servers = 3" >> /etc/php/php-fpm.conf

