#! /bin/bash

if [ $(uname -m) == "armv6l" ]; then export ARCH=armhf ; elif [ $(uname -m) == "armv7l" ]; then export ARCH=armhf ; elif [ $(uname -m) == "x86_64" ]; then export ARCH=x86_64 ; fi

if [ -d "/usr/share/docker-engine/contrib" ]; then
  MKIMAGESCRIPT="/usr/share/docker-engine/contrib/mkimage.sh"
else
  cd /tmp
  curl -sL https://github.com/docker/docker/archive/master.tar.gz | tar xz
  chmod +x /tmp/docker-master/contrib/mkimage.sh
  MKIMAGESCRIPT="/tmp/docker-master/contrib/mkimage.sh"
fi

TAGPREFIX=maxder/debian-mini
SUITES="stretch"

for suite in ${SUITES}; do
  $MKIMAGESCRIPT -t ${TAGPREFIX}:${ARCH} debootstrap --variant=minbase ${suite} http://httpredir.debian.org/debian
done

if [ $MKIMAGESCRIPT = "/tmp/docker-master/contrib/mkimage.sh"  ]; then
  rm -rf /tmp/docker-master
fi

exit 0
