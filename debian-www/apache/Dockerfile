FROM maxder/debian-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apt-get update \
 && apt-get install -y apache2 apache2-utils \
 && echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf \
 && a2enconf servername
 
RUN rm -rf /etc/s6/services/s6-fdholderd/down 
COPY rootfs /
EXPOSE 80/tcp 443/tcp
