#!/bin/bash

if [ -d "/usr/share/docker-engine/contrib" ]; then
  MKIMAGE="/usr/share/docker-engine/contrib/mkimage.sh"
else
  curl -o /tmp/maxder_debian-mini_mkimage.sh -L https://raw.githubusercontent.com/docker/docker/master/contrib/mkimage.sh
  chmod +x /tmp/maxder_debian-mini_mkimage.sh
  MKIMAGE="/tmp/maxder_debian-mini_mkimage.sh"
fi

TAGPREFIX=maxder/debian-mini
SUITES="jessie"

for suite in ${SUITES}; do 
  $MKIMAGE -t ${TAGPREFIX}:ARCHTAG debootstrap --variant=minbase ${suite} http://httpredir.debian.org/debian
done
