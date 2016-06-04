FROM maxder/alpine-base:x86_64
MAINTAINER Christian-Maxilian Steier

ENV ETHERPAD_VERSION 1.6.0

RUN echo "http://nl.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories \
 && apk -U add \
 	make \
 	nodejs \
 	python \
	curl \
	openssl \
	zlib \
	libuv \
	mariadb-client \
	pwgen \
	rsync

ADD https://github.com/ether/etherpad-lite/archive/${ETHERPAD_VERSION}.tar.gz /tmp/etherpad.tar.gz
WORKDIR /tmp
RUN if [ ! -d /usr/share/webapps ]; then mkdir /usr/share/webapps ;fi \
 && tar -xvzf etherpad.tar.gz \
 && cd etherpad-lite-${ETHERPAD_VERSION} \
 && rsync \
    --delete \
    --exclude 'CHANGELOG.md'\
    --exclude 'CONTRIBUTING.md'\
    --exclude 'LICENSE'\
    --exclude 'README.md'\
    --exclude 'Makefile'\
    --exclude 'settings.json'\
    --exclude '.git'\
    --exclude '.gitignore'\
    --exclude '.travis.yml'\
    --exclude 'bin/buildDebian.sh'\
    --exclude 'bin/buildForWindows.sh'\
    --exclude 'bin/deb-src'\
    --exclude 'bin/installOnWindows.bat'\
    --exclude 'doc/'\
    --exclude 'start.bat'\
    --exclude 'tests/'\
    --exclude 'var/'\
    -a . /usr/share/webapps/etherpad

WORKDIR /usr/share/webapps/etherpad
RUN bin/installDeps.sh \
 && touch APIKEY.txt \
 && echo "$(pwgen -s -1 16)" > APIKEY.txt

ADD service /etc/service
RUN chmod +x /etc/service/*/*

RUN touch /firstrun
RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp /tmp/*

EXPOSE 9001
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
