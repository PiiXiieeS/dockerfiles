FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ENV VERSION 10.2

RUN apk -U add alpine-sdk cmake libxml2-dev libxslt-dev mbedtls-dev --update-cache --repository http://dl-4.alpinelinux.org/alpine/edge/community/  --allow-untrusted
ADD https://www.hiawatha-webserver.org/files/hiawatha-${VERSION}.tar.gz /tmp/hiawatha.tar.gz
RUN tar -xvzf /tmp/hiawatha.tar.gz -C /tmp/ \
 && cd /tmp/hiawatha-* \
 && cmake . -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_INSTALL_BINDIR=/usr/bin \
    -DCMAKE_INSTALL_SBINDIR=/usr/sbin \
    -DCMAKE_INSTALL_SYSCONFDIR=/etc/hiawatha \
    -DCMAKE_INSTALL_LIBDIR=/usr/lib \
    -DCMAKE_INSTALL_MANDIR=/usr/share/man \
    -DCONFIG_DIR=/etc/hiawatha \
    -DLOG_DIR=/var/log/hiawatha \
    -DPID_DIR=/var/run \
    -DUSE_SYSTEM_MBEDTLS=ON \
    -DWEBROOT_DIR=/var/www/hiawatha \
    -DWORK_DIR=/var/lib/hiawatha \
 && make \
 && make install \
 && apk del alpine-sdk cmake 
RUN sed -i 's|#ServerId = www-data|ServerId = nobody|' /etc/hiawatha/hiawatha.conf \
 && sed -i 's|www-data|nobody|g' /tmp/hiawatha-*/logrotate.d/hiawatha \
 && install -Dm644 /tmp/hiawatha-*/logrotate.d/hiawatha /etc/logrotate.d/hiawatha

ADD service /etc/service
RUN chmod +x /etc/service/*/*

#ADD conf/hiawatha.conf /etc/hiawatha/hiawatha.conf
#ADD conf/hiawatha_localhost.conf /etc/hiawatha/sites-available/localhost.conf
RUN if [ ! -d "/etc/hiawatha/sites-enabled" ]; then mkdir /etc/hiawatha/sites-enabled ;fi \
 && echo "Include /etc/hiawatha/sites-enabled/" >> /etc/hiawatha/hiawatha.conf \
 && ln -s /etc/hiawatha/sites-available/localhost.conf  /etc/hiawatha/sites-enabled/

RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp /tmp/*

EXPOSE 80 443
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
