FROM maxder/debianbase
MAINTAINER Christian-Maximilian Steier
ENV TP_VERSION 2.1.19
ENV PATH_TEAMPASS /var/www/html/teampass

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
    wget \
    git

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

# Install TeamPass
RUN git clone https://github.com/nilsteampassnet/TeamPass.git ${PATH_TEAMPASS}
RUN cd ${PATH_TEAMPASS} && git checkout $TP_VERSION
RUN chmod 777 ${PATH_TEAMPASS}/install/ ${PATH_TEAMPASS}/includes/ ${PATH_TEAMPASS}/files/ ${PATH_TEAMPASS}/upload/
RUN sed -i -e 's/max_execution_time = 30/max_execution_time = 600/g' /etc/php5/apache2/php.ini
RUN php5enmod mcrypt

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
#CMD ["/sbin/my_init"]
