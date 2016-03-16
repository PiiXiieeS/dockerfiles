FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN echo "http://dl-4.alpinelinux.org/alpine/v3.3/main/"      | tee /etc/apk/repositories    \
 && echo "http://dl-4.alpinelinux.org/alpine/v3.3/community/" | tee -a /etc/apk/repositories \
 && apk -U --no-progress upgrade
RUN apk --no-cache --no-progress add ca-certificates nginx

ADD service /etc/service
RUN chmod +x /etc/service/*/*

ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/nginx_localhost.conf /etc/nginx/conf.d/localhost.conf
RUN if [ ! -d "/etc/nginx/sites-enabled" ]; then mkdir /etc/nginx/sites-enabled ;fi \
 && echo "charset utf-8;" > /etc/nginx/conf.d/charset.conf \
 && echo "client_max_body_size 1G;" > /etc/nginx/conf.d/uploads.conf

EXPOSE 80 443
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
