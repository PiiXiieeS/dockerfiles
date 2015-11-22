FROM maxder/PLACEHOLDER-base:edge
MAINTAINER Christian-Maximilian Steier

RUN apk add nginx --update-cache

ADD service /etc/service
RUN ln -s /bin/true /etc/service/nginx/finish \
 && chmod +x /etc/service/*/* \
 && sed -i "s*#error_log  logs/error.log  info*error_log /dev/stdout info*g" /etc/nginx/nginx.conf \
 && sed -i "s*#access_log  logs/host.access.log  main*access_log /dev/stdout*g" /etc/nginx/nginx.conf

EXPOSE 80

RUN cat /etc/nginx/nginx.conf

ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]


