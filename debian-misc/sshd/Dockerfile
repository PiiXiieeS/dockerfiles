FROM maxder/debian-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN rm -rf \
    /etc/s6/services/s6-fdholderd/down \
    /etc/s6/services/sshd/down \
    /etc/s6/services/cron
 
EXPOSE 22
