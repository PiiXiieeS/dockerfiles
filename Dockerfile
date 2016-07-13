FROM phusion/baseimage:0.9.18
MAINTAINER Christian-Maximilian

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

# FFmpeg
ENV FFMPEG_VERSION 2.3.3
ADD http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 /usr/local/src/ffmpeg-${FFMPEG_VERSION}.tar.bz2
WORKDIR /usr/local/src
RUN apt-get install -y build-essential git-core checkinstall yasm texi2html libvorbis-dev libx11-dev libvpx-dev libxfixes-dev zlib1g-dev pkg-config netcat libncurses5-dev
RUN tar -xjf ffmpeg-${FFMPEG_VERSION}.tar.bz2 \
 && cd ffmpeg-${FFMPEG_VERSION} \
 && ./configure --enable-version3 --enable-postproc --enable-libvorbis --enable-libvpx \
 && make \
 && checkinstall --pkgname=ffmpeg --pkgversion="5:${FFMPEG_VERSION}" --backup=no --deldoc=yes --default

RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

EXPOSE 5060/tcp 5060/udp 5080/tcp 5080/udp 5066/tcp 7443/tcp 8021/tcp 16384-32768/udp 64535-65535/udp
