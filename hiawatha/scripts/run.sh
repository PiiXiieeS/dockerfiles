#!/bin/bash

sed -i "s*DOMAIN*${VIRTUAL_HOST}*g" /etc/hiawatha/hiawatha.conf
exec supervisord -n
