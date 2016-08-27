#!/bin/bash

set -e
 source /bd_build/buildconfig
set -x

$minimal_apt_get_install cron
mkdir -p /etc/s6/services/cron
chmod 600 /etc/crontab
cp /bd_build/services/cron/cron.run /etc/s6/services/cron/run
echo "\#!/bin/execlineb -S0" /etc/s6/services/cron/finish

## Remove useless cron entries.
# Checks for lost+found and scans for mtab.
rm -f /etc/cron.daily/standard
rm -f /etc/cron.daily/upstart
rm -f /etc/cron.daily/dpkg
rm -f /etc/cron.daily/password
rm -f /etc/cron.weekly/fstrim
