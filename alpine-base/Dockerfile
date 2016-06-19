FROM maxder/alpine-mini:armhf
MAINTAINER Christian-Maxilian Steier

ENV RELEASE v3.4
RUN echo "http://nl.alpinelinux.org/alpine/$RELEASE/main/" > /etc/apk/repositories    \
 && echo "http://nl.alpinelinux.org/alpine/$RELEASE/community/" >> /etc/apk/repositories \
 && apk -U --no-progress upgrade
RUN apk -U --no-progress add bash s6 linux-pam

ADD service /etc/service
RUN mkdir -p /var/spool/cron/crontabs

# Bash/Prompt customization
RUN echo "PS1='\[\033[40;1;37m\][`date +%H:%M:%S`]\[\033[0m\] [\[\033[1;31m\]\u\[\033[0m\]@\h]:\[\033[01;34m\]\w\[\033[00m\]\$  '" >> /root/.bashrc

RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp

ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
