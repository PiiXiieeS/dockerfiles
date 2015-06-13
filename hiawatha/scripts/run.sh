#!/bin/bash

if [ -z "$VIRTUAL_HOST" ]; then
        sed -i "s*DOMAIN*0.0.0.0*g" /etc/hiawatha/hiawatha.conf
else
        sed -i "s*DOMAIN*$VIRTUAL_HOST*g" /etc/hiawatha/hiawatha.conf
fi
exec supervisord -n
