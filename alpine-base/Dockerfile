FROM maxder/PLACEHOLDER-mini:edge
MAINTAINER Christian-Maxilian Steier

RUN apk --update add bash s6

ADD service /etc/service

RUN mkdir -p /var/spool/cron/crontabs
RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp

ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
