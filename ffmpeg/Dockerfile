FROM maxder/ubuntu-bbb-base
MAINTAINER Christian-Maximilian

ENV FFMPEG_VERSION 2.3.3

# Set locale to en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ADD http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 /usr/local/src/ffmpeg-${FFMPEG_VERSION}.tar.bz2
WORKDIR /usr/local/src
RUN apt-get install -y build-essential git-core checkinstall yasm texi2html libvorbis-dev libx11-dev libvpx-dev libxfixes-dev zlib1g-dev pkg-config netcat libncurses5-dev
RUN tar -xjf ffmpeg-${FFMPEG_VERSION}.tar.bz2 \
 && cd ffmpeg-${FFMPEG_VERSION} \
 && ./configure --enable-version3 --enable-postproc --enable-libvorbis --enable-libvpx \
 && make \
 && checkinstall --pkgname=ffmpeg --pkgversion="5:${FFMPEG_VERSION}" --backup=no --deldoc=yes --default

RUN ffmpeg -version
