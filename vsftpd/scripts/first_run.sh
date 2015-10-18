#!/bin/bash
set -e

if [ -f /firstrun ]; then
  sed -i "s*DOCKERHOST*$DOCKER_HOST*g" /etc/vsftpd.conf
  openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem -subj "/CN=$DOCKER_HOST"
  rm /firstrun
fi
exit 0
