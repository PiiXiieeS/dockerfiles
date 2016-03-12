FROM maxder/PLACEHOLDER-base:edge
MAINTAINER Christian-Maxilian Steier

RUN echo "http://dl-4.alpinelinux.org/alpine/v3.3/main/"      | tee /etc/apk/repositories    \
 && echo "http://dl-4.alpinelinux.org/alpine/v3.3/community/" | tee -a /etc/apk/repositories \
 && apk -U --no-progress upgrade
RUN apk --no-cache --no-progress add ca-certificates nginx

ADD service /etc/service
RUN chmod +x /etc/service/*/*

ADD conf/nginx.conf /etc/nginx/nginx.conf
RUN if [ ! -d "/etc/nginx/conf.d" ]; then mkdir /etc/nginx/conf.d ;fi

EXPOSE 80 443
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
