FROM maxder/alpine-base:edge
MAINTAINER Christian-Maxilian Steier

ENV ETHERPAD_VERSION 1.5.7

ADD https://github.com/christiansteier/alpine-repo/raw/master/x86_64/nodejs-0.12.9-r0.apk /tmp/nodejs-0.12.9-r0.apk
RUN apk -U add --allow-untrusted \
	openssl \
	 zlib \
	libuv \
	mysql-client \
	pwgen \
	curl \
	/tmp/nodejs-0.12.9-r0.apk

RUN npm -g install npm \
 && npm cache clean \
 && rm /tmp/nodejs-0.12.9-r0.apk

WORKDIR /opt/

ADD https://github.com/ether/etherpad-lite/archive/${ETHERPAD_VERSION}.tar.gz /tmp/etherpad.tar.gz
RUN cd /tmp \
 && tar -xvzf /tmp/etherpad.tar.gz \ 
 && rm /tmp/etherpad.tar.gz \
 && mv /tmp/etherpad-lite-${ETHERPAD_VERSION} /opt/etherpad-lite

WORKDIR /opt/etherpad-lite

ENV HOME /opt/etherpad-lite
RUN bin/installDeps.sh \
 && rm settings.json \
 && touch APIKEY.txt \
 && echo "$(pwgen -s -1 16)" > APIKEY.txt

VOLUME /opt/etherpad-lite/var
RUN ln -s var/settings.json settings.json

ADD service /etc/service
RUN chmod +x /etc/service/*/*

RUN touch /firstrun

EXPOSE 9001

ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
