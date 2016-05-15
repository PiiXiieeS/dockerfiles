FROM maxder/alpine-base:ARCHTAG
MAINTAINER Christian-Maxilian Steier

RUN echo "http://dl-4.alpinelinux.org/alpine/v3.3/main/"      | tee /etc/apk/repositories    \
 && echo "http://dl-4.alpinelinux.org/alpine/v3.3/community/" | tee -a /etc/apk/repositories \
 && apk -U --no-progress upgrade
RUN apk --no-cache --no-progress add ca-certificates nginx

ADD service /etc/service
RUN chmod +x /etc/service/*/*

ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/nginx-headers.conf /etc/nginx/headers.conf
ADD conf/nginx_localhost.site /etc/nginx/localhost.site
RUN if [ ! -d "/etc/nginx/sites-enabled" ]; then mkdir /etc/nginx/sites-enabled ;fi \
 && echo "charset utf-8;" > /etc/nginx/conf.d/charset.conf \
 && echo "client_max_body_size 2G;" > /etc/nginx/conf.d/uploads.conf

# Cleanup and security fixes
RUN rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp /tmp/* /etc/fstab \
 && rm -fr /etc/init.d /lib/rc /etc/conf.d /etc/inittab /etc/runlevels /etc/rc.conf \
 && rm -fr /etc/sysctl* /etc/modprobe.d /etc/modules /etc/mdev.conf /etc/acpi \
 && find $sysdirs -xdev -type l -exec test ! -e {} \; -delete \
 && sed -i -r '/^(www-data|nginx|root)/!d' /etc/group \
 && sed -i -r '/^(nginx|root)/!d' /etc/passwd \
 && sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd

EXPOSE 80 443
ENTRYPOINT ["/bin/s6-svscan", "-t0"]
CMD ["/etc/service"]
