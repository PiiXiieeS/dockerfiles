FROM maxder/debianbase
MAINTAINER Christian-Maximilian Steier
ENV OWNCLOUD_VERSION 8.1
ENV OWNCLOUD_RELEASE 1

ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    apache2 \
    libapache2-mod-php5 \
    php5 \
    php5-gd \
    php-xml-parser \
    php5-intl \
    php5-mysqlnd \
    php5-json \
    php5-mcrypt \
    php5-apcu \
    php5-memcache \
    memcached \
    smbclient \
    php5-curl \
    bzip2 \
    graphviz \
    wget \
    libav-tools

# Adding additional memcached daemon
RUN mkdir /etc/service/memcached
ADD service/memcached.sh /etc/service/memcached/run
RUN chmod +x /etc/service/memcached/run

# Set timezone
RUN echo "Europe/Berlin" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

## PageSpeed Module
RUN cd /tmp && wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-beta_current_amd64.deb
RUN cd /tmp && dpkg -i mod-pagespeed-*.deb && apt-get -f install

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## PHP config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 500M/g" /etc/php5/apache2/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 500M/g" /etc/php5/apache2/php.ini
RUN sed -i -e "s/short_open_tag\s*=\s*Off/short_open_tag = On/g" /etc/php5/apache2/php.ini

RUN curl -k https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.${OWNCLOUD_RELEASE}.tar.bz2 | tar jx -C /var/www/
RUN mkdir /data
RUN chown -R www-data:www-data /var/www/owncloud

# Apache2
ADD conf/apache-default.conf /etc/apache2/sites-available/000-default.conf
RUN \
        a2enmod rewrite headers \
        && echo "ServerName localhost" >> /etc/apache2/apache2.conf \
        && sed -i "s*NameVirtualHost*#NameVirtualHost*g" /etc/apache2/ports.conf

# User
RUN usermod -c "ownCloud" root && usermod -c "ownCloud" www-data

ADD conf/rc.local /etc/rc.local
RUN chown root:root /etc/rc.local

VOLUME ["/data", "/var/www/owncloud/config"]
EXPOSE 80
