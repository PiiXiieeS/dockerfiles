FROM debian:jessie
MAINTAINER Christian-Maximilian
# Minimal Debian baseimage modified for Docker-friendliness, 
# based on phusion/baseimage-docker

ENV S6_VERSION 1.17
ENV S6_RELEASE 2.0

# Scripts
ADD . /bd_build
RUN /bd_build/scripts/prepare.sh && \
	/bd_build/scripts/system_services.sh && \
	/bd_build/scripts/utilities.sh && \
	/bd_build/scripts/cleanup.sh

ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
