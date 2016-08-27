FROM maxder/debian-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apt-get update \
 && apt-get install -y nginx
RUN if [ ! -d "/etc/nginx/sites-enabled" ]; then mkdir /etc/nginx/sites-enabled ;fi \
 && echo "charset utf-8;" > /etc/nginx/conf.d/charset.conf \
 && echo "client_max_body_size 2G;" > /etc/nginx/conf.d/uploads.conf
 
RUN rm -rf /etc/s6/services/s6-fdholderd/down 
COPY rootfs /
EXPOSE 80/tcp 443/tcp
