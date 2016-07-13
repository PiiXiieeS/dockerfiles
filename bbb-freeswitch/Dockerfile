FROM maxder/ubuntu-bbb-ffmpeg
MAINTAINER Christian-Maximilian

# Set locale to en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install -y --force-yes bbb-freeswitch

EXPOSE 5060/tcp 5060/udp 5080/tcp 5080/udp 5066/tcp 7443/tcp 8021/tcp 16384-32768/udp 64535-65535/udp

