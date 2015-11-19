FROM maxder/rpi-alpine-mini:edge
MAINTAINER Christian-Maxilian Steier

RUN apk --update add bash s6 \
 && rm -f /var/cache/apk/*

ADD service /etc/service

RUN mkdir -p /var/spool/cron/crontabs

ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
