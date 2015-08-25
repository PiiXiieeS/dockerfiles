

MAHARA_WWWROOT=${MAHARA_WWWROOT:-/mahara}
MAHARA_EMAIL=${MAHARA_EMAIL:-contact@domain.org}
MAHARA_DB=${MAHARA_DB:-mahara}
MAHARA_PASS=${MAHARA_PASS:-$(pwgen -s -1 16)}
MAHARA_SALD=${MAHARA_SALD:-$(pwgen -s -1 16)}
MAHARA_ADMPASS=${MAHARA_DB:-mahara}

pre_start_action() {

if [ ! -f /var/www/html/mahara/config.php ]; then
  cp -ax /var/www/html/mahara/config-dist.php /var/www/html/mahara/config.php
  sed -i "s|dbtype   = 'postgres'|dbtype   = 'mysql'|g" /var/www/html/mahara/config.php
  sed -i "s|dbname   = ''|dbname   = '$MAHARA_DB'|g" /var/www/html/mahara/config.php
  sed -i "s|dbuser   = ''|dbuser   = '$MAHARA_DB'|g" /var/www/html/mahara/config.php  
  sed -i "s|dbpass   = ''|dbpass   = '$MAHARA_PASS'|g" /var/www/html/mahara/config.php
  sed -i "s|dbhost   = 'localhost'|dbhost   = '$DBHOST'|g" /var/www/html/mahara/config.php
  sed -i 's|\/\/ \$cfg->wwwroot|\$cfg->wwwroot|g' /var/www/html/mahara/config.php
  sed -i "s|wwwroot = 'https:\/\/myhost.com\/mahara\/'|wwwroot = '$MAHARA_WWWROOT'|g" /var/www/html/mahara/config.php
  sed -i "s|dataroot = '\/path\/to\/uploaddir'|dataroot = '\/var\/maharadata'|g" /var/www/html/mahara/config.php
  sed -i 's|\/\/ \$cfg->passwordsaltmain|\$cfg->passwordsaltmain|g' /var/www/html/mahara/config.php
  sed -i "s|passwordsaltmain = 'some long random string here with lots of characters'|passwordsaltmain = '$MAHARA_SALD'|g" /var/www/html/mahara/config.php
  sed -i "s|emailcontact = ''|emailcontact = '$MAHARA_EMAIL'|g" /var/www/html/mahara/config.php
  sed -i "s|\/\/ closing php tag intentionally omitted to prevent whitespace issues|\$cfg->cleanurls = true;\n\$cfg->cleanurlinvalidcharacters = '/[^a-zA-Z0-9]+/';\$cfg->cleanurlvalidate = '/^[a-z0-9-]*\$/';\n\$cfg->cleanurlusereditable = true;\n\n\/\/ closing php tag intentionally omitted to prevent whitespace issues|g" /var/www/html/mahara/config.php
  chown www-data:www-data /var/www/html/mahara/config.php
fi

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
# German
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


}

post_start_action() {

  DB_MAINT_PASS=$(cat /etc/mysql/debian.cnf | grep -m 1 "password\s*=\s*"| sed 's/^password\s*=\s*//')
  mysql -u root -e \
      "GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY '$DB_MAINT_PASS';"

 echo "Create database user $MAHARA_DB and database $MAHARA_DB"
  mysql -u root <<-EOF
      CREATE USER '$MAHARA_DB'@'localhost' IDENTIFIED BY '$MAHARA_PASS';
      CREATE DATABASE $MAHARA_DB CHARACTER SET utf8;
      GRANT ALL PRIVILEGES ON $MAHARA_DB.* TO $MAHARA_DB@localhost IDENTIFIED BY '$MAHARA_PASS';
      FLUSH PRIVILEGES;
EOF

  #php /var/www/html/mahara/admin/cli/install.php --verbose --adminpassword='$MAHARA_ADMPASS' --adminemail=$MAHARA_EMAIL

  rm /firstrun

  echo " "
  echo "---"
  echo " "
}
