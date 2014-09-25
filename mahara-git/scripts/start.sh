#!/bin/bash
if [ ! -f /var/www/html/mahara/config.php ]; then
  #mysql has to be started this way as it doesn't work to call from /etc/init.d
  /usr/bin/mysqld_safe & 
  sleep 10s
  # Here we generate random passwords (thank you pwgen!). The first two are for mysql users, the last batch for random keys in wp-config.php
  MAHARA_DB="mahara"
  MYSQL_PASSWORD=`pwgen -c -n -1 12`
  MAHARA_PASSWORD=`pwgen -c -n -1 12`
  MAHARA_SALD=`pwgen -c -n -1 24`
  #This is so the passwords show up in logs. 
  echo mysql root password: $MYSQL_PASSWORD
  echo mahara password: $MAHARA_PASSWORD
  echo ssh root password: $SSH_PASSWORD
  echo root:$SSH_PASSWORD | chpasswd
  echo $MYSQL_PASSWORD > /mysql-root-pw.txt
  echo $MAHARA_PASSWORD > /mahara-db-pw.txt
  echo $SSH_PASSWORD > /ssh-pw.txt

  cp -ax /var/www/html/mahara/config-dist.php /var/www/html/mahara/config.php
  sed -i "s|dbtype   = 'postgres'|dbtype   = 'mysql'|g" /var/www/html/mahara/config.php
  sed -i "s|dbname   = ''|dbname   = '$MAHARA_DB'|g" /var/www/html/mahara/config.php
  sed -i "s|dbuser   = ''|dbuser   = '$MAHARA_DB'|g" /var/www/html/mahara/config.php
  sed -i "s|dbpass   = ''|dbpass   = '$MAHARA_PASSWORD'|g" /var/www/html/mahara/config.php
  sed -i 's|\/\/ \$cfg->wwwroot|\$cfg->wwwroot|g' /var/www/html/mahara/config.php
  sed -i "s|wwwroot = 'https:\/\/myhost.com\/mahara\/'|wwwroot = '$MAHARA_WWWROOT'|g" /var/www/html/mahara/config.php
  sed -i "s|dataroot = '\/path\/to\/uploaddir'|dataroot = '\/var\/maharadata'|g" /var/www/html/mahara/config.php
  sed -i 's|\/\/ \$cfg->passwordsaltmain|\$cfg->passwordsaltmain|g' /var/www/html/mahara/config.php
  sed -i "s|passwordsaltmain = 'some long random string here with lots of characters'|passwordsaltmain = '$MAHARA_SALD'|g" /var/www/html/mahara/config.php
  sed -i "s|emailcontact = ''|emailcontact = '$MAHARA_EMAIL'|g" /var/www/html/mahara/config.php

  echo 'root:root' |chpasswd
  sed -i 's/PermitRootLogin without-password/PermitRootLogin Yes/' /etc/ssh/sshd_config
  sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

  chown www-data:www-data /var/www/html/mahara/config.php

  echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION;" > /tmp/mahara.sql
  echo "CREATE DATABASE "$MAHARA_DB" CHARACTER SET utf8 COLLATE utf8_general_ci;" >> /tmp/mahara.sql
  echo "GRANT ALL PRIVILEGES ON "$MAHARA_DB".* TO '"$MAHARA_DB"'@'localhost' IDENTIFIED BY '"$MAHARA_PASSWORD"';" >> /tmp/mahara.sql
  echo "FLUSH PRIVILEGES;" >>  /tmp/mahara.sql
  mysqladmin -u root password $MYSQL_PASSWORD
  mysql -uroot -p$MYSQL_PASSWORD < /tmp/mahara.sql
  killall mysqld
fi
# start all the services
/usr/local/bin/supervisord -n
