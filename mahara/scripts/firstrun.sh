#!/bin/bash

MAHARA_WWWROOT=${MAHARA_WWWROOT:-/mahara}
MAHARA_EMAIL=${MAHARA_EMAIL:-contact@domain.org}

if [ ! -f /var/www/html/mahara/config.php ]; then

	MAHARA_DB="mahara"
	MAHARA_PASSWORD=`pwgen -c -n -1 12`
  	MAHARA_SALD=`pwgen -c -n -1 24`

	cp -ax /var/www/html/mahara/config-dist.php /var/www/html/mahara/config.php
	sed -i "s|dbtype   = 'postgres'|dbtype   = 'mysql'|g" /var/www/html/mahara/config.php
	sed -i "s|dbname   = ''|dbname   = '$MAHARA_DB'|g" /var/www/html/mahara/config.php
	sed -i "s|dbuser   = ''|dbuser   = '$MAHARA_DB'|g" /var/www/html/mahara/config.php
  	sed -i "s|dbpass   = ''|dbpass   = '$MAHARA_PASSWORD'|g" /var/www/html/mahara/config.php
        sed -i "s|dbhost   = 'localhost'|dbhost   = '127.0.0.1'|g" /var/www/html/mahara/config.php
  	sed -i 's|\/\/ \$cfg->wwwroot|\$cfg->wwwroot|g' /var/www/html/mahara/config.php
  	sed -i "s|wwwroot = 'https:\/\/myhost.com\/mahara\/'|wwwroot = '$MAHARA_WWWROOT'|g" /var/www/html/mahara/config.php
  	sed -i "s|dataroot = '\/path\/to\/uploaddir'|dataroot = '\/var\/maharadata'|g" /var/www/html/mahara/config.php
  	sed -i 's|\/\/ \$cfg->passwordsaltmain|\$cfg->passwordsaltmain|g' /var/www/html/mahara/config.php
  	sed -i "s|passwordsaltmain = 'some long random string here with lots of characters'|passwordsaltmain = '$MAHARA_SALD'|g" /var/www/html/mahara/config.php
  	sed -i "s|emailcontact = ''|emailcontact = '$MAHARA_EMAIL'|g" /var/www/html/mahara/config.php
  	sed -i "s|\/\/ closing php tag intentionally omitted to prevent whitespace issues|\$cfg->cleanurls = true;\n\$cfg->cleanurlinvalidcharacters = '/[^a-zA-Z0-9]+/';\$cfg->cleanurlvalidate = '/^[a-z0-9-]*\$/';\n\$cfg->cleanurlusereditable = true;\n\n\/\/ closing php tag intentionally omitted to prevent whitespace issues|g" /var/www/html/mahara/config.php
  	chown www-data:www-data /var/www/html/mahara/config.php
  	echo "CREATE DATABASE "$MAHARA_DB" CHARACTER SET utf8 COLLATE utf8_general_ci;" >> /tmp/mahara.sql
  	echo "GRANT ALL PRIVILEGES ON "$MAHARA_DB".* TO '"$MAHARA_DB"'@'%' IDENTIFIED BY '"$MAHARA_PASSWORD"';" >> /tmp/mahara.sql
  	echo "FLUSH PRIVILEGES;" >>  /tmp/mahara.sql
  	mysql -u "$USER" --password="$PASS" -h "127.0.0.1" < /tmp/mahara.sql
	echo " " && echo " --- " && echo " "

 ## Clearn URL
 if [ -f /etc/apache2/sites-available/000-default.conf ]; then
 	a2enmod rewrite
 	sed -i "s*</VirtualHost>*\n                <IfModule mod_rewrite.c>\n                        RewriteEngine on\n                        RewriteRule ^/mahara/user/([a-z0-9-]+)/?\$ /mahara/user/view.php?profile=\$1\&%{QUERY_STRING}\n                        RewriteRule ^/mahara/user/([a-z0-9-]+)/([a-z0-9-]+)/?\$ /mahara/view/view.php?profile=\$1\&page=\$2&%{QUERY_STRING}\n                        RewriteRule ^/mahara/group/([a-z0-9-]+)/?\$ /mahara/group/view.php?homepage=\$1\&%{QUERY_STRING}\n                        RewriteRule ^/mahara/group/([a-z0-9-]+)/([a-z0-9-]+)/?\$ /mahara/view/view.php?homepage=\$1\&page=\$2\&%{QUERY_STRING}\n                </IfModule>\n</VirtualHost>*g" /etc/apache2/sites-available/000-default.conf
 echo " " && echo " --- " && echo " "
 fi

 ## Redirection to Mahara
 if [ -f /etc/apache2/sites-available/000-default.conf ]; then
	sed -i "s*DocumentRoot /var/www/html*DocumentRoot /var/www/html \n                        DirectoryIndex index.php*g" /etc/apache2/sites-available/000-default.conf
 fi
 echo -e "<?php \nheader('Location: /mahara'); \n?>" >> /var/www/html/index.php
 chown www-data:www-data /var/www/html/index.php

 ## Language pack

 ## German
 cd /tmp/
 if curl --output /dev/null --silent --head --fail "http://langpacks.mahara.org/de-MAHARA_VERSION_STABLE.tar.gz"; then
 	wget http://langpacks.mahara.org/de-MAHARA_VERSION_STABLE.tar.gz
 else
        wget http://langpacks.mahara.org/de-master.tar.gz
 fi

 if [ ! -d /var/maharadata/langpacks  ]; then
	mkdir /var/maharadata/langpacks
 fi

tar -xf de-* -C /var/maharadata/langpacks/
chown -R www-data:www-data /var/maharadata/langpacks/de.utf8
rm -r /tmp/de*
echo " " && echo " --- " && echo " "
fi

