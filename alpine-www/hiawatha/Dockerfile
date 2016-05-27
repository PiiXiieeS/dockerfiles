FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

ENV VERSION 10.2

RUN apk -U add musl mbedtls libxml2 libxslt zlib alpine-sdk cmake libxml2-dev libxslt-dev mbedtls-dev --repository http://nl.alpinelinux.org/alpine/edge/community/ --allow-untrusted
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
 && apk del alpine-sdk cmake libxml2-dev libxslt-dev mbedtls-dev \
 && install -Dm644 /tmp/hiawatha-*/logrotate.d/hiawatha /etc/logrotate.d/hiawatha \
 && addgroup -Sg 82 www-data \
 && adduser -S -D -H -h /var/lib/hiawatha -s /sbin/nologin -G www-data -g www-data hiawatha 
RUN sed -i "s*GENERAL SETTINGS*GENERAL SETTINGS\nLogFormat = extended\nServerString = SimpleHTTPserver\n*g;s*\#ServerId = www-data*ServerId = hiawatha*g" /etc/hiawatha/hiawatha.conf \
 && sed -i "s*\#Binding*Binding \{\n       Port = 443\n       TLScertFile = tls/hiawatha.pem\n       MaxRequestSize = 2048 #2MB\n       TimeForRequest = 300\n\}\n\n\#Binding*g" /etc/hiawatha/hiawatha.conf

ADD service /etc/service
RUN chmod +x /etc/service/*/*

RUN if [ ! -d "/etc/hiawatha/sites-enabled" ]; then mkdir /etc/hiawatha/sites-enabled ;fi \
 && echo "Include /etc/hiawatha/sites-enabled/" >> /etc/hiawatha/hiawatha.conf

RUN apk --no-progress add openssl \
 &&  openssl genrsa -out /etc/hiawatha/hiawatha.pem 4096 \
 && openssl req -new -x509 -days 3650 -key /etc/hiawatha/hiawatha.pem -out /tmp/hiawatha.crt -subj "/C=US/CN=0.0.0.0" \
 && echo "" >> /etc/hiawatha/hiawatha.pem \
 && cat /tmp/hiawatha.crt >> /etc/hiawatha/hiawatha.pem \
 && echo "" >> /etc/hiawatha/hiawatha.pem \
 && apk del openssl

# Cleanup and security fixes
COPY scripts/cleanup.sh /tmp/cleanup.sh
RUN /tmp/cleanup.sh \
 && touch /firstrun

EXPOSE 80 443
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
