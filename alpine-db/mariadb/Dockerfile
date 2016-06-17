FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apk -U --no-progress add \
	mariadb \
	mariadb-client \
	tzdata \
	pwgen

ADD service /etc/service
RUN rm -r /etc/service/cron \
 && chmod +x /etc/service/*/*

RUN touch /firstrun \
 && rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp

EXPOSE 3306
VOLUME ["/var/lib/mysql"]
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
