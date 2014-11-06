FROM eboraas/debootstrap:minbase-wheezy
MAINTAINER Christian-Maxilian Steier

ADD http://http.debian.net/debian/project/trace/ftp-master.debian.org /etc/trace_ftp-master.debian.org
ADD http://security.debian.org/project/trace/security-master.debian.org /etc/trace_security-master.debian.org

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade

# Basic Requirements
RUN apt-get -y install mysql-server mysql-client pwgen python-setuptools curl git unzip

# Moodle Requirements
RUN apt-get -y install apache2 php5 php5-gd libapache2-mod-php5 postfix wget supervisor php5-pgsql vim curl libcurl3 libcurl3-dev php5-curl php5-xmlrpc php5-intl php5-mysql
RUN cd /tmp; wget http://coredump.id.au/blog/wp-content/php5-zendopcache_7.0.3-5_amd64.deb; dpkg -i php5-zendopcache_7.0.3-5_amd64.deb; rm php5-zendopcache_7.0.3-5_amd64.deb

# SSH
RUN apt-get -y install openssh-server
RUN mkdir -p /var/run/sshd

# MariaDB
RUN apt-get -y install \
        python-software-properties && \
        apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db && \
        add-apt-repository 'deb http://mirror.netcologne.de/mariadb/repo/10.1/debian wheezy main'
RUN apt-get update && apt-get -y install \
        mariadb-server \
        mariadb-client
ADD scripts/mariadb.sh /tmp/mariadb.sh
RUN chmod +x /tmp/mariadb.sh
RUN /tmp/mariadb.sh
RUN rm /tmp/mariadb.sh

RUN easy_install supervisor
ADD scripts/start.sh /start.sh
ADD scripts/foreground.sh /etc/apache2/foreground.sh
ADD conf/supervisord.conf /etc/supervisord.conf

ADD http://downloads.sourceforge.net/project/moodle/Moodle/stable27/moodle-latest-27.tgz /var/www/moodle-latest-27.tgz
RUN cd /var/www; tar zxvf moodle-latest-27.tgz
RUN chown -R www-data:www-data /var/www/moodle
RUN mkdir /var/moodledata
RUN chown -R www-data:www-data /var/moodledata; chmod 777 /var/moodledata
RUN chmod 755 /start.sh /etc/apache2/foreground.sh

EXPOSE 22 80
CMD ["/bin/bash", "/start.sh"]

