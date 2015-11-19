FROM maxder/PLACEHOLDER-base:edge
MAINTAINER Christian-Maxilian Steier
# Based on kost/docker-alpine/alpine-mariadb

RUN apk --update add mysql mysql-client pwgen \
 && rm -f /var/cache/apk/*

ADD scripts/run.sh /scripts/run.sh
RUN mkdir /scripts/pre-exec.d \
 && mkdir /scripts/pre-init.d \
 && chmod -R 755 /scripts

EXPOSE 3306

VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/scripts/run.sh"]

