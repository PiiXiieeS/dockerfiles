#!/bin/bash

sed -i ':a;N;$!ba;s/\n/WILDCARD/g' /var/www/hiawatha/index.html
if [ -z "$VIRTUAL_HOST" ]; then
	sed -i "s*DOMAIN*0.0.0.0*g" /etc/hiawatha/hiawatha.conf
	sed -i "s*</div>WILDCARD</body*<h2>Viewing your PHP Settings</h2><p>You can now access phpinfo page under <a href='http://0.0.0.0/phpinfo/'>/phpinfo</a>.</p></div>WILDCARD</body*g" /var/www/hiawatha/index.html
else
	sed -i "s*DOMAIN*$VIRTUAL_HOST*g" /etc/hiawatha/hiawatha.conf
	sed -i "s*</div>WILDCARD</body*<h2>Viewing your PHP Settings</h2><p>You can now access phpinfo page under <a href='http://${VIRTUAL_HOST}/phpinfo/'>/phpinfo</a>.</p></div>WILDCARD</body*g" /var/www/hiawatha/index.html
fi
sed -i "s*WILDCARD*\n*g" /var/www/hiawatha/index.html
exec supervisord -n
