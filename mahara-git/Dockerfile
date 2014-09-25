FROM ubuntu:14.04
MAINTAINER Christian-Maximilian Steier 

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade

# Set timezone
RUN locale-gen de_DE.UTF-8
RUN echo "Europe/Berlin" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
 
# Basic Requirements
RUN apt-get -y install pwgen python-setuptools curl git unzip

# Mahara Requirements
RUN apt-get -y install apache2 cron file libjs-jquery perl php5 php-file php-htmlpurifier php-pear php5-cli php5-curl php5-gd php5-mysql php5-imagick php-xml-parser php5-intl php-services-json tinymce ttf-bitstream-vera ttf-freefont

# SSH
RUN apt-get -y install openssh-server
RUN mkdir -p /var/run/sshd

# MariaDB
RUN apt-get -y install mariadb-server mariadb-client
ADD scripts/mariadb.sh /tmp/mariadb.sh
RUN chmod +x /tmp/mariadb.sh
RUN /tmp/mariadb.sh
RUN rm /tmp/mariadb.sh

RUN easy_install supervisor
ADD scripts/start.sh /start.sh
ADD scripts/foreground.sh /etc/apache2/foreground.sh
ADD conf/supervisord.conf /etc/supervisord.conf

## PHP config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/apache2/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/apache2/php.ini
RUN sed -i -e "s/short_open_tag\s*=\s*Off/short_open_tag = On/g" /etc/php5/apache2/php.ini

## Mahara
RUN cd /tmp && git clone https://gitorious.org/mahara/mahara.git
RUN cp -ax /tmp/mahara/htdocs /var/www/html/mahara
RUN chown -R www-data:www-data /var/www/html/mahara
RUN rm -r /tmp/mahara
RUN mkdir /var/maharadata
RUN chown -R www-data:www-data /var/maharadata; chmod 777 /var/maharadata
RUN chmod 755 /start.sh /etc/apache2/foreground.sh

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22 3306 80
CMD ["/bin/bash", "/start.sh"]

