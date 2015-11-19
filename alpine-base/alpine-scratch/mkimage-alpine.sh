#!/bin/sh
set -e -x

[ $(id -u) -eq 0 ] || {
  printf >&2 '%s requires root\n' "$0"
  exit 1
}

usage() {
  printf >&2 '%s: [-r release] [-m mirror] [-s]\n' "$0"
  exit 1
}

tmp() {
  TMP=$(mktemp -d /tmp/alpine-docker-XXXXXXXXXX)
  ROOTFS=$(mktemp -d /tmp/alpine-docker-rootfs-XXXXXXXXXX)
  trap "rm -rf $TMP $ROOTFS" EXIT TERM INT
}

apkv() {
  set -x
  curl -s $REPO/$ARCH/APKINDEX.tar.gz | tar -Oxz |
    grep '^P:apk-tools-static$' -a -A1 | tail -n1 | cut -d: -f2
}

getapk() {
  curl -s $REPO/$ARCH/apk-tools-static-$(apkv).apk |
    tar -xz -C $TMP sbin/apk.static
}

mkbase() {
  $TMP/sbin/apk.static --repository $REPO --update-cache --allow-untrusted \
    --root $ROOTFS --initdb add alpine-base
}

conf() {
  printf '%s\n' $REPO > $ROOTFS/etc/apk/repositories
}

pack() {
  local id
  id=$(tar --numeric-owner -C $ROOTFS -c . | docker import - $DOCKERTAG:$REL)

  docker tag -f $id $DOCKERTAG
  #alpine:latest
  #docker images
  #docker run -i -t $DOCKERTAG:$REL printf $DOCKERTAG':%s with id=%s created!\n' $REL $id
}

save() {
  [ $SAVE -eq 1 ] || return

  tar --numeric-owner -C $ROOTFS -c . | xz > rootfs.tar.xz
}

:<<COM
while getopts "hr:m:s" opt; do
  case $opt in
    r)
      REL=$OPTARG
      ;;
    m)
      MIRROR=$OPTARG
      ;;
    s)
      SAVE=1
      ;;
    *)
      usage
      ;;
  esac
done
COM

DOCKERTAG=${IMAGENAME:-alpine}
REL=${REL:-edge}
MIRROR=${MIRROR:-http://nl.alpinelinux.org/alpine}
SAVE=${SAVE:-0}
REPO=$MIRROR/$REL/main
if [ $(uname -m) == "armv6l" ]; then
        ARCH="armhf"
else
        ARCH=$(uname -m)
fi

tmp && getapk && mkbase && conf && pack
# && save
