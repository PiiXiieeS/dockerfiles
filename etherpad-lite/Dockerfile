# Based on the Dockerfile of Tony Motakis: https://github.com/tvelocity/dockerfiles/tree/master/etherpad-lite
FROM maxder/debianbase
MAINTAINER Christian-Maximilian Steier 

ENV ETHERPAD_VERSION 1.5.7

ADD scripts/first_run.sh /etc/my_init.d/firstrun.sh
RUN chmod +x /etc/my_init.d/firstrun.sh
RUN touch /firstrun

RUN apt-get update
RUN apt-get install -y \
    nodejs \
    npm \
    pwgen \
    mariadb-client

RUN ln /usr/bin/nodejs /usr/bin/node

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/

RUN curl -SL \
    https://github.com/ether/etherpad-lite/archive/${ETHERPAD_VERSION}.tar.gz > etherpad.tar.gz \
 && tar -xf etherpad.tar.gz \ 
 && rm etherpad.tar.gz \
 && mv etherpad-lite-${ETHERPAD_VERSION} etherpad-lite

WORKDIR etherpad-lite

RUN bin/installDeps.sh \
 && rm settings.json \
 && touch APIKEY.txt \
 && echo "$(pwgen -s -1 16)" > APIKEY.txt

VOLUME /opt/etherpad-lite/var
RUN ln -s var/settings.json settings.json

# Add apache to runit 
RUN mkdir /etc/service/etherpad
ADD service/etherpad.sh /etc/service/etherpad/run
RUN chmod +x /etc/service/etherpad/run

EXPOSE 9001
