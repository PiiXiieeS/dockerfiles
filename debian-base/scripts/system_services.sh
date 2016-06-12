#!/bin/bash
set -e
 source /bd_build/buildconfig
set -x

## Install s6
$minimal_apt_get_install curl
curl -o /tmp/s6-overlay.tar.gz -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}.${S6_RELEASE}/s6-overlay-amd64.tar.gz
tar xzf /tmp/s6-overlay.tar.gz -C /

## Install a syslog daemon and logrotate.
[ "$DISABLE_SYSLOG" -eq 0 ] && /bd_build/services/syslog-ng/syslog-ng.sh || true

## Install the SSH server.
[ "$DISABLE_SSH" -eq 0 ] && /bd_build/services/sshd/sshd.sh || true

## Install cron daemon.
[ "$DISABLE_CRON" -eq 0 ] && /bd_build/services/cron/cron.sh || true

