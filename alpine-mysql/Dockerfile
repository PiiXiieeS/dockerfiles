FROM maxder/rpi-alpine-base:edge
MAINTAINER Christian-Maxilian Steier
# Based on kost/docker-alpine/alpine-mariadb

RUN apk --update add mysql mysql-client pwgen \
 && rm -f /var/cache/apk/*

ADD service /etc/service
RUN rm -r /etc/service/cron \
 && chmod +x /etc/service/mysql/*

EXPOSE 3306
RUN touch /firstrun

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
