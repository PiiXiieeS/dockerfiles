FROM eboraas/debootstrap:minbase-jessie
MAINTAINER Christian-Maxilian Steier
ENV HIAWATHA_VERSION 9.13
#ENV VIRTUAL_HOST domain.org

ADD http://http.debian.net/debian/project/trace/ftp-master.debian.org /etc/trace_ftp-master.debian.org
ADD http://security.debian.org/project/trace/security-master.debian.org /etc/trace_security-master.debian.org

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl
# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Set timezone
RUN echo "Europe/Berlin" > /etc/timezone \ 
 && dpkg-reconfigure -f noninteractive tzdata

# Install basics
RUN apt-get update
RUN apt-get install  -y \ 
 vim \
 supervisor \ 
 wget \
 logrotate \
 unzip \
 apache2-utils \
 libxml2 \
 libxslt1.1 

# Hiawatha
RUN cd /tmp \
 && wget http://files.tuxhelp.org/hiawatha/hiawatha_${HIAWATHA_VERSION}_amd64.deb \
 && dpkg -i *.deb \
 && rm *.deb
ADD conf/hiawatha.conf /etc/hiawatha/hiawatha.conf

# Clean up APT when done.
RUN apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD scripts/start.sh /start.sh
ADD scripts/run.sh /run.sh
RUN chmod 755 /*.sh
ADD conf/supervisord-hiawatha.conf /etc/supervisor/conf.d/supervisord-hiawatha.conf

EXPOSE 80
CMD ["/run.sh"]
