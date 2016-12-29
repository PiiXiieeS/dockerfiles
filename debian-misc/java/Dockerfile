FROM maxder/debian-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

# Oracle Java 1.8
RUN apt-get update \
 && apt-get install -y debconf-utils gnupg2
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list \
 && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
 && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
 && apt-get update \
 && apt-get install -y oracle-java8-installer \
 && java -version

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /tmp/* /etc/s6/services/cron
