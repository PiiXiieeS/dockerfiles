#! /bin/bash

sysdirs="
  /bin
  /etc
  /lib
  /sbin
  /usr
"
find $sysdirs -xdev -regex '.*apk.*' -exec rm -fr {} +
find $sysdirs -xdev -type f -regex '.*-$' -exec rm -f {} +
find $sysdirs -xdev -type l -exec test ! -e {} \; -delete
find $sysdirs -xdev -type d \
  -exec chown root:root {} \; \
  -exec chmod 0755 {} \;
find $sysdirs -xdev -type f -a -perm +4000 -delete
find $sysdirs -xdev \( \
  -name hexdump -o \
  -name chgrp -o \
  -name ln -o \
  -name od -o \
  -name strings -o \
  -name su \
  \) -delete

sed -i -r '/^(www-data|nginx|root)/!d' /etc/group
sed -i -r '/^(nginx|root)/!d' /etc/passwd
sed -i -r 's#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd

rm -rf /var/cache/apk/* /usr/share/doc /usr/share/man/ /usr/share/info/* /var/cache/man/* /var/tmp /tmp /etc/fstab
rm -fr /etc/init.d /lib/rc /etc/conf.d /etc/inittab /etc/runlevels /etc/rc.conf 
rm -fr /etc/sysctl* /etc/modprobe.d /etc/modules /etc/mdev.conf /etc/acpi

exit 0
