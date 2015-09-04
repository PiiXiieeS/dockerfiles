#!/bin/bash
set -e

MOODLE_DB=${MOODLE_DB:-moodle}
MOODLE_PASS=${MOODLE_PASS:-$(pwgen -s -1 16)}
MOODLE_SALD=${MOODLE_SALD:-$(pwgen -s -1 16)}
MOODLE_WWWROOT=${MOODLE_WWWROOT:-/moodle}
DBADMIN=${DBADMIN:-$DB_ENV_USER}
DBPASS=${DBPASS:-$DB_ENV_PASS}
DBHOST=${DBHOST:-$DB_PORT_3306_TCP_ADDR}

pre_start_action() {

if [ ! -f /var/www/html/moodle/config.php ]; then
#  sed -i "s*/var/www/html*/var/www/html/moodle*g" /etc/apache2/sites-available/000-default.conf
  cp -ax /var/www/html/moodle/config-dist.php /var/www/html/moodle/config.php
  sed -i "s*pgsql*mariadb*g" /var/www/html/moodle/config.php
  sed -i "s*localhost*$DBHOST*g" /var/www/html/moodle/config.php
  sed -i "s*username*$MOODLE_DB*g" /var/www/html/moodle/config.php
  sed -i "s*password*$MOODLE_PASS*g" /var/www/html/moodle/config.php
  sed -i "s*example.com*$MOODLE_WWWROOT*g" /var/www/html/moodle/config.php
  sed -i "s*\/home\/example\/moodledata*\/var\/moodledata*g" /var/www/html/moodle/config.php
  chown www-data:www-data /var/www/html/moodle/config.php
  chown -R www-data:www-data /var/moodledata
fi

}

post_start_action() {

 echo "Create database user $MOODLE_DB and database $MOODLE_DB"
  mysql -u $DBADMIN --password=$DBPASS -h $DBHOST <<-EOF
      CREATE DATABASE IF NOT EXISTS $MOODLE_DB CHARACTER SET utf8;
      GRANT ALL PRIVILEGES ON $MOODLE_DB.* TO $MOODLE_DB IDENTIFIED BY '$MOODLE_PASS';
      FLUSH PRIVILEGES;
EOF

  rm /firstrun

  echo " "
  echo "---"
  echo " "
  echo "Database: $MOODLE_DB"
  echo "Password: $MOODLE_PASS"
  echo "Sald: $MOODLE_SALD"
  echo "www_root: $MOODLE_WWWROOT"
  echo " "
  echo "---"
  echo " "
}

if [ -f /firstrun ]; then

  pre_start_action
  post_start_action

fi

exit 0
