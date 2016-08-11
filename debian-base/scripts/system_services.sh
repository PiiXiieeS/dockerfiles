#!/bin/bash
set -e
 source /bd_build/buildconfig
set -x

## Install s6
$minimal_apt_get_install curl
if [ $(uname -m) == "armv6l" ]; then curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}.${S6_RELEASE}/s6-overlay-armhf.tar.gz ; elif [ $(uname -m) == "armv7l" ]; then curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}.${S6_RELEASE}/s6-overlay-armhf.tar.gz ; elif [ $(uname -m) == "x86_64" ]; then curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}.${S6_RELEASE}/s6-overlay-amd64.tar.gz ; fi
tar xzf /tmp/s6-overlay.tar.gz -C /

## Install the SSH server.
[ "$DISABLE_SSH" -eq 0 ] && /bd_build/services/sshd/sshd.sh || true

## Install cron daemon.
[ "$DISABLE_CRON" -eq 0 ] && /bd_build/services/cron/cron.sh || true

