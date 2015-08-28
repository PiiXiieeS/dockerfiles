FROM maxder/debianbase
MAINTAINER Christian-Maxilian Steier

# Ensure UTF-8
RUN locale-gen en_US.UTF-8

# Install MariaDB from repository.
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server

# Install other tools.
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y pwgen inotify-tools expect

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3306
ADD scripts /scripts
RUN chmod +x /scripts/start.sh
RUN touch /firstrun
RUN chmod +x /scripts/tuning_mariadb.sh
RUN /scripts/tuning_mariadb.sh
RUN rm -r /etc/service/cron

# Expose our data, log, and configuration directories.
VOLUME ["/var/log/mysql", "/etc/mysql"]

# Use baseimage-docker's init system.
CMD ["/sbin/my_init", "--", "/scripts/start.sh"]
