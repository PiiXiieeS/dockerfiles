FROM maxder/debian-php-fpm:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apt-get update \
 && apt-get install -y apache2 apache2-utils \
 && echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf \
 && a2enconf servername \
 && a2enmod ssl

RUN apt-get install -y openssl \
 && openssl genrsa -out /etc/apache2/apache.pem 4096 \ 
 && openssl req -new -x509 -days 3650 -key /etc/apache2/apache.pem -out /etc/apache2/apache.crt -subj "/C=US/CN=0.0.0.0"
 
RUN rm -rf /etc/s6/services/s6-fdholderd/down 
COPY rootfs /
EXPOSE 80/tcp 443/tcp
