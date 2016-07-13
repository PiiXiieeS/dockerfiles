FROM phusion/baseimage:0.9.18
MAINTAINER Christian-Maximilian

RUN apt-get update \
 && apt-get upgrade -y

# Set locale to en_US.UTF-8
RUN apt-get install language-pack-en \
 && update-locale LANG=en_US.UTF-8 \
 && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Add 'trusty multiverse' in sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse" >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get dist-upgrade -y

# Install PPA for LibreOffice 4.4 and libssl
RUN apt-get install software-properties-common \
 && add-apt-repository ppa:libreoffice/libreoffice-4-4 \
 && add-apt-repository -y ppa:ondrej/php

# Install key for BigBlueButton
RUN curl http://ubuntu.bigbluebutton.org/bigbluebutton.asc | apt-key add - \
 && echo "deb http://ubuntu.bigbluebutton.org/trusty-1-0/ bigbluebutton-trusty main" >> /etc/apt/sources.list.d/bigbluebutton.list \
 && apt-get update
