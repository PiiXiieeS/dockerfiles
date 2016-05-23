FROM maxder/alpine-mini:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ENV RELEASE v3.3
RUN echo "http://nl.alpinelinux.org/alpine/$RELEASE/main/" > /etc/apk/repositories    \
 && echo "http://nl.alpinelinux.org/alpine/$RELEASE/community/" >> /etc/apk/repositories \
 && apk -U --no-progress upgrade
RUN apk -U --no-progress add bash s6 linux-pam
ADD service /etc/service

RUN mkdir -p /var/spool/cron/crontabs
RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp

ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
