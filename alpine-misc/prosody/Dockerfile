FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apk -U --no-progress --repository http://nl.alpinelinux.org/alpine/edge/testing add prosody \
 && sed -i "s*daemonize \= true*daemonize \= false*g"  /etc/prosody/prosody.cfg.lua

ADD service /etc/service
RUN rm -r /etc/service/cron \
 && chmod +x /etc/service/*/*

RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp \
 && touch /firstrun 

EXPOSE 80 443 5222 5269 5347 5280 5281
ENV __FLUSH_LOG yes
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
