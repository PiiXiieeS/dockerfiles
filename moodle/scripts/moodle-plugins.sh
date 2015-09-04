#!/bin/bash

MOODLEROOT=/var/www/html/moodle

mkdir /tmp/moodle-plugins && cd /tmp/moodle-plugins

## Themes

# Theme Essential by Julian Ridden, maintained by Gareth J Barnard
wget https://github.com/gjb2048/moodle-theme_essential/tarball/master
tar -xf master && rm master
mv *-moodle-theme_essential* $MOODLEROOT/theme/essential
chown -R www-data:www-data $MOODLEROOT/theme/essential

# Theme Anomaly
wget https://github.com/moodlehq/moodle-theme_anomaly/tarball/master
tar -xf master && rm master
mv moodlehq-moodle-theme_anomaly* $MOODLEROOT/theme/anomaly
chown -R www-data:www-data $MOODLEROOT/theme/anomaly

# Theme BCU by Mike Grant, Jez H Jez H
wget https://moodle.org/plugins/download.php/8050/theme_bcu_moodle28_2015022500.zip
unzip theme_bcu_moodle28_2015022500.zip
mv bcu $MOODLEROOT/theme/bcu
chown -R www-data:www-data $MOODLEROOT/theme/bcu

## General plugins (Local)

# Moodle Mobile additional features maintained by Juan Leyva
wget https://github.com/jleyva/moodle-local_mobile/tarball/master
tar -xf master && rm master
mv jleyva-moodle-local_mobile* $MOODLEROOT/local/mobile
chown -R www-data:www-data $MOODLEROOT/local/mobile

rm -r /tmp/moodle-plugins

exit 0
