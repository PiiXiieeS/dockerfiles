#!/bin/bash
set -e

if [ -f /firstrun ]; then
sed -i "s*DOCKERHOST*$DOCKER_HOST*g" /etc/vsftpd.conf
rm /firstrun
fi

exit 0
