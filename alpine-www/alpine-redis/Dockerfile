FROM maxder/alpine-base:armhf
MAINTAINER Christian-Maxilian Steier

RUN apk -U add redis \
 && sed 's/^daemonize yes/daemonize no/' -i /etc/redis.conf \
 && sed 's/^loglevel notice/loglevel debug/' -i /etc/redis.conf \
 && sed "s*/var/log/redis/redis.log*/dev/stdout*g" -i /etc/redis.conf \
 && if [ $(uname -m) == "armv6l" ]; then sed "s*# maxmemory <bytes>*maxmemory 67108864*g" -i /etc/redis.conf ; elif [ $(uname -m) == "armv7l" ]; then sed "s*# maxmemory <bytes>*maxmemory 67108864*g" -i /etc/redis.conf ; fi

RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp

ADD service /etc/service
RUN chmod +x /etc/service/*/*

EXPOSE 6379/tcp
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
