#!/bin/bash
set -e

if [ "$LOCAL" -a  "$PASSWORD" -a "$DOMAIN" ] ; then
    sed -i "s*XMPP_DOMAIN*$LOCAL*g" /00prosody.cfg.lua
    mv /00prosody.cfg.lua /etc/prosody/conf.d/00prosody.cfg.lua 
    prosodyctl restart && prosodyctl register $LOCAL $DOMAIN $PASSWORD
fi

exec "$@"

exit 0
