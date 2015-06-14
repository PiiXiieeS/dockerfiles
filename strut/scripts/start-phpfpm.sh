#!/bin/bash
exec php5-fpm -c /etc/php5/fpm/php.ini -y /etc/php5/fpm/php-fpm.conf -R
