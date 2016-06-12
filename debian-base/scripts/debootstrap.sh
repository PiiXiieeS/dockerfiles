#!/bin/bash

TAGPREFIX=maxder/debian-mini:
SUITES="jessie"

for suite in ${SUITES}; do 
  /usr/share/docker-engine/contrib/mkimage.sh -t ${TAGPREFIX}${suite} debootstrap --variant=minbase ${suite} http://httpredir.debian.org/debian
done
