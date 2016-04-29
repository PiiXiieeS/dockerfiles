FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ENV ETHERPAD_VERSION 1.6.0

RUN apk -U add \
	openssl \
	zlib \
	libuv \
	mysql-client \
	pwgen


ENV pkgver=0.12.9
ADD https://nodejs.org/dist/v$pkgver/node-v$pkgver.tar.gz /tmp/nodejs.tar.gz
RUN apk -U add \
	alpine-sdk \
	python \ 
	openssl-dev \
	zlib-dev \
	libuv-dev \
        linux-headers \
	paxmark \
	binutils-gold
Run cd /tmp \
 && tar xzf /tmp/nodejs.tar.gz -C /tmp/ \
 && cd node* \
 && ./configure --prefix=/usr \
                --shared-zlib \
                --shared-libuv \
                --shared-openssl \
 && make -C out mksnapshot BUILDTYPE=Release \
 && paxmark -m out/Release/mksnapshot \
 && make \
 && make install \
 && paxmark -m /usr/bin/node \
 && cp -pr /usr/lib/node_modules/npm/man /usr/share

RUN npm -g install npm \
 && npm cache clean

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
