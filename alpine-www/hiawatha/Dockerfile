FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN apk -U --no-progress --repository http://nl.alpinelinux.org/alpine/edge/community add mbedtls \
 && apk -U --no-progress --repository http://nl.alpinelinux.org/alpine/edge/testing add hiawatha
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
