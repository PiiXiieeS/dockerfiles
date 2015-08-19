FROM maxder/debianbase
MAINTAINER Christian-Maximilian Steier
ENV PPMA_VERSION 0.5.1

RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Install Apache
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
    apache2 \
    libapache2-mod-php5 \
    php5-mysqlnd \
    php5-mcrypt \
    wget

# Enable PHP 
RUN a2enmod php5

# Manually set the apache environment variables in order to get apache to work immediately. 
RUN echo www-data > /etc/container_environment/APACHE_RUN_USER
RUN echo www-data > /etc/container_environment/APACHE_RUN_GROUP
RUN echo /var/log/apache2 > /etc/container_environment/APACHE_LOG_DIR
RUN echo /var/lock/apache2 > /etc/container_environment/APACHE_LOCK_DIR
RUN echo /var/run/apache2.pid > /etc/container_environment/APACHE_PID_FILE

# Add apache to runit RUN mkdir /etc/service/apache
ADD service/apache.sh /etc/service/apache/run
RUN chmod +x /etc/service/apache/run

# Install PPMA
RUN wget http://sourceforge.net/projects/ppma/files/$PPMA_VERSION/ppma-$PPMA_VERSION.tar.gz && \
 tar -xf ppma-$PPMA_VERSION.tar.gz && \
 rm ppma-$PPMA_VERSION.tar.gz && \
 mv ppma* /var/www/html/ppma && \
 chown -R www-data:www-data /var/www/html/ppma

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
#CMD ["/sbin/my_init"]
