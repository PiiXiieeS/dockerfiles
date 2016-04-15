FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier


ENV REDIS_DATA_DIR=/var/lib/redis \
    REDIS_LOG_DIR=/var/log/redis

RUN echo "http://dl-4.alpinelinux.org/alpine/v3.3/main/"      | tee /etc/apk/repositories    \
 && echo "http://dl-4.alpinelinux.org/alpine/v3.3/community/" | tee -a /etc/apk/repositories \
 && apk -U --no-progress upgrade
RUN apk --no-cache --no-progress add redis \
 && sed 's/^daemonize yes/daemonize no/' -i /etc/redis.conf \
 && sed 's/^# bind 127.0.0.1/bind 0.0.0.0/' -i /etc/redis.conf \
 && sed 's/^# unixsocket /unixsocket /' -i /etc/redis.conf \
 && sed 's/^# unixsocketperm 700/unixsocketperm 777/' -i /etc/redis.conf \
 && sed '/^logfile/d' -i /etc/redis.conf
RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp

ADD service /etc/service
RUN chmod +x /etc/service/*/*

EXPOSE 6379/tcp
VOLUME ["${REDIS_DATA_DIR}"]
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
