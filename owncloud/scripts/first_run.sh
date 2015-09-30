#!/bin/bash
set -e

OC_DB=${OC_DB:-owncloud}
OC_PASS=${OC_PASS:-$(pwgen -s -1 16)}
DBHOST=${DBHOST:-$DB_PORT_3306_TCP_ADDR}
DBADMIN=${DBADMIN:-$DB_ENV_USER}
DBPASS=${DBPASS:-$DB_ENV_PASS}
OCADMIN=${OCADMIN:-ocadmin}
OCPASS=${OCADMIN:-ocadmin}
OCSALT==${OCSALT:-$(pwgen -s -1 16)}

if [ ! -z "$MYSQL_PORT_3306_TCP_ADDR" ]; then
	sed -i "s/.*dbhost.*/  'dbhost' => '$MYSQL_PORT_3306_TCP_ADDR',/" /var/www/owncloud/config/config.php
fi

if [ -f /firstrun ]; then
  mv /autoconfig.php  /var/www/owncloud/config/autoconfig.php
  chown -R www-data:www-data  /var/www/owncloud/config/autoconfig.php
  sed -i "s*DBUSER*$OC_DB*g"  /var/www/owncloud/config/autoconfig.php
  sed -i "s*DBPASS*$OC_PASS*g"  /var/www/owncloud/config/autoconfig.php
  sed -i "s*DBHOST*$DBHOST*g"  /var/www/owncloud/config/autoconfig.php
  sed -i "s*DBNAME*$OC_DB*g"  /var/www/owncloud/config/autoconfig.php
  sed -i "s*OCADMIN*$OCADMIN*g"  /var/www/owncloud/config/autoconfig.php
  sed -i "s*OCPASS*$OCPASS*g"  /var/www/owncloud/config/autoconfig.php
  sed -i "s*OCSALT*$OCSALT*g"  /var/www/owncloud/config/autoconfig.php
  
  echo "Create database user $OC_DB and database $OC_DB"
  mysql -u $DBADMIN --password=$DBPASS -h $DBHOST <<-EOF
      CREATE DATABASE IF NOT EXISTS $OC_DB CHARACTER SET utf8;
      GRANT ALL PRIVILEGES ON $OC_DB.* TO $OC_DB IDENTIFIED BY '$OC_PASS';
      FLUSH PRIVILEGES;
EOF

  echo -e  "<?php \n\$CONFIG = array (\n  'memcache.local' => '\\OC\\Memcache\\APCu',\n);" > /var/www/owncloud/config/config.php
  chown www-data:www-data /var/www/owncloud/config/config.php
 rm /firstrun

fi

exit 0
