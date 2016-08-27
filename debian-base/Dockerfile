FROM maxder/debian-mini:ARCHTAG
MAINTAINER Christian-Maximilian
# Minimal Debian baseimage with s6, 
# based on phusion/baseimage-docker

ENV S6_VERSION 1.18
ENV S6_RELEASE 1.3

# Scripts
ADD . /bd_build
RUN /bd_build/scripts/prepare.sh && \
	/bd_build/scripts/system_services.sh && \
	/bd_build/scripts/utilities.sh && \
	/bd_build/scripts/cleanup.sh

# Bash/Prompt customization
RUN echo "PS1='\[\033[40;1;37m\][`date +%H:%M:%S`]\[\033[0m\] [\[\033[1;31m\]\u\[\033[0m\]@\h]:\[\033[01;34m\]\w\[\033[00m\]\$  '" >> /root/.bashrc

ENTRYPOINT ["/init"]
CMD []
