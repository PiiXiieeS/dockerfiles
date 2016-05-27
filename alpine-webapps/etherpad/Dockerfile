FROM maxder/alpine-base:x86_64
MAINTAINER Christian-Maxilian Steier

ENV ETHERPAD_VERSION 1.6.0

RUN echo "http://nl.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories \
 && apk -U add nodejs \
	curl \
	openssl \
	zlib \
	libuv \
	mariadb-client \
	pwgen

WORKDIR /opt/

ADD https://github.com/ether/etherpad-lite/archive/${ETHERPAD_VERSION}.tar.gz /tmp/etherpad.tar.gz
RUN cd /tmp \
 && tar -xvzf /tmp/etherpad.tar.gz \
 && mv /tmp/etherpad-lite-${ETHERPAD_VERSION} /opt/etherpad-lite

WORKDIR /opt/etherpad-lite
ENV HOME /opt/etherpad-lite
RUN bin/installDeps.sh \
 && rm settings.json \
 && touch APIKEY.txt \
 && echo "$(pwgen -s -1 16)" > APIKEY.txt

ADD service /etc/service
RUN chmod +x /etc/service/*/*

RUN touch /firstrun
RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp /tmp/*

EXPOSE 9001
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
