FROM eboraas/debootstrap:minbase-jessie
MAINTAINER Christian-Maxilian Steier

ENV MOODLE_VERSION 28

ADD http://http.debian.net/debian/project/trace/ftp-master.debian.org /etc/trace_ftp-master.debian.org
ADD http://security.debian.org/project/trace/security-master.debian.org /etc/trace_security-master.debian.org

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Basic Requirements
RUN apt-get update \
 && apt-get -y install \
	pwgen \
	python-setuptools \
	curl \
	wget \
	git \
	unzip \
	vim \
	supervisor \
	locales \
	cron

# Set Lang
RUN export LANG=de_DE.UTF-8 && locale-gen de_DE.UTF-8

# Set timezone
RUN echo "Europe/Berlin" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# MariaDB
RUN apt-get update \ 
 && apt-get -y install \
	software-properties-common \
 && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db \
 && add-apt-repository 'deb http://mirror.netcologne.de/mariadb/repo/10.0/debian wheezy main' \
 && apt-get update \
 && apt-get -y install \
	mariadb-server \
        mariadb-client
ADD scripts/mariadb.sh /tmp/mariadb.sh
RUN chmod +x /tmp/mariadb.sh
RUN /tmp/mariadb.sh
RUN rm /tmp/mariadb.sh

# Moodle Requirements
RUN apt-get update \
 && apt-get -y install \
	postfix \
	apache2 \
	php5 \
	php5-gd \
	libapache2-mod-php5 \
	php5-pgsql \
	libcurl3 \
	libcurl3-dev \
	php5-curl \
	php5-xmlrpc \
	php5-intl \
	php5-mysql \
	memcached \
	php-pear \
	php5-memcached \
	php5-xcache \
	ghostscript

# Moodle
ADD http://downloads.sourceforge.net/project/moodle/Moodle/stable${MOODLE_VERSION}/moodle-latest-${MOODLE_VERSION}.tgz /var/www/html/moodle-latest-${MOODLE_VERSION}.tgz
RUN cd /var/www/html && tar zxvf moodle-latest-${MOODLE_VERSION}.tgz \
 && chown -R www-data:www-data /var/www/html/moodle \
 && rm moodle-latest-${MOODLE_VERSION}.tgz \
 && mkdir /var/moodledata \
 && chown -R www-data:www-data /var/moodledata \
 && chmod 777 /var/moodledata
RUN echo "* * * * * www-data php /var/www/html/moodle/admin/cli/cron.php >/dev/null" >> /etc/crontab
RUN sed -i 's*DocumentRoot /var/www/html*DocumentRoot /var/www/html\n        RedirectMatch 303 ^/?\$ /moodle*g' /etc/apache2/sites-available/000-default.conf 
RUN usermod -c "Moodle" www-data                                                                                                                                                              

# Moosh by Tomasz Muras
RUN apt-add-repository 'deb http://ppa.launchpad.net/zabuch/ppa/ubuntu precise main' \
 && apt-get update \
 && apt-get install moosh

# Moodle plugins
ADD scripts/moodle-plugins.sh /moodle-plugins.sh
RUN chmod 755 /moodle-plugins.sh \
 && /bin/bash /moodle-plugins.sh \
 && rm /moodle-plugins.sh

# SSH
RUN apt-get -y install \
	openssh-server \
 && mkdir -p /var/run/sshd
RUN pwgen -c -n -1 12 > /ssh-pw.txt \
 && echo "root:$(cat /ssh-pw.txt)" | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
## SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN easy_install supervisor
ADD scripts/start.sh /start.sh
ADD scripts/foreground.sh /etc/apache2/foreground.sh
ADD conf/supervisord.conf /etc/supervisord.conf
RUN chmod 755 /start.sh /etc/apache2/foreground.sh

EXPOSE 22 80
CMD ["/bin/bash", "/start.sh"]

