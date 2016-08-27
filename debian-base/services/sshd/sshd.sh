#!/bin/bash

set -e
 source /bd_build/buildconfig
set -x

SSHD_BUILD_PATH=/bd_build/services/sshd

## Install the SSH server.
$minimal_apt_get_install openssh-server
mkdir /var/run/sshd
mkdir -p /etc/s6/services/sshd
touch /etc/s6/services/sshd/down
cp $SSHD_BUILD_PATH/sshd.run /etc/s6/services/sshd/run
cp $SSHD_BUILD_PATH/sshd_config /etc/ssh/sshd_config
cp $SSHD_BUILD_PATH/regen_ssh_host_keys.sh /usr/sbin/
chmod +x /usr/sbin/regen_ssh_host_keys.sh
mkdir -p /etc/cont-init.d
echo '#!/bin/execlineb -P\nif -t { s6-test ! -d /usr/sbin/regen_ssh_host_keys.sh }\nif { s6-chmod 100 /usr/sbin/regen_ssh_host_keys.sh }\nif { /usr/sbin/regen_ssh_host_keys.sh }' > /etc/cont-init.d/00-regen_ssh_host_keys

## Install default SSH key for root and app.
mkdir -p /root/.ssh
chmod 700 /root/.ssh
chown root:root /root/.ssh
cp $SSHD_BUILD_PATH/keys/insecure_key.pub /etc/insecure_key.pub
cp $SSHD_BUILD_PATH/keys/insecure_key /etc/insecure_key
chmod 644 /etc/insecure_key*
chown root:root /etc/insecure_key*
cp $SSHD_BUILD_PATH/enable_insecure_key /usr/sbin/
chmod +x /usr/sbin/enable_insecure_key
