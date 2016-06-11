FROM maxder/debian-base
MAINTAINER Christian-Maxilian Steier

RUN apt-get update \
 && apt-get install -y nginx
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/nginx-headers.conf /etc/nginx/headers.conf
ADD conf/nginx_localhost.site /etc/nginx/localhost.site
RUN if [ ! -d "/etc/nginx/sites-enabled" ]; then mkdir /etc/nginx/sites-enabled ;fi \
 && echo "charset utf-8;" > /etc/nginx/conf.d/charset.conf \
 && echo "client_max_body_size 2G;" > /etc/nginx/conf.d/uploads.conf
 
RUN openssl genrsa -out /etc/nginx/nginx.pem 4096 \
 && openssl req -new -x509 -days 3650 -key /etc/nginx/nginx.pem -out /etc/nginx/nginx.crt -subj "/C=US/CN=0.0.0.0" \
 && apt-get purge -y openssl

ADD service/nginx /etc/service/nginx
RUN chmod +x /etc/service/*/*

# Cleanup and security fixes
#COPY scripts/cleanup.sh /tmp/cleanup.sh
#RUN /tmp/cleanup.sh

EXPOSE 80/tcp 443/tcp
