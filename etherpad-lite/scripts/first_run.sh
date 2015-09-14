#!/bin/bash
set -e

if [ -f /firstrun ]; then

  ETHERPAD_DB_NAME=${ETHERPAD_DB_NAME:-etherpad}
  ETHERPAD_DB_USER=${ETHERPAD_DB_USER:-etherpad}
  ETHERPAD_DB_PASS=${ETHERPAD_DB_PASS:-$(pwgen -s -1 16)}
  ETHERPAD_TITLE=${ETHERPAD_TITLE:-Etherpad}
  ETHERPAD_SESSION_KEY=${ETHERPAD_SESSION_KEY:-$(
                node -p "require('crypto').randomBytes(32).toString('hex')")}
  ETHERPAD_ADMIN_USER=${ETHERPAD_ADMIN_USER:-admin}
  ETHERPAD_ADMIN_PASS=${ETHERPAD_ADMIN_PASS-$(pwgen -s -1 16)}
  DBADMIN=${DBADMIN:-$DB_ENV_USER}
  DBPASS=${DBPASS:-$DB_ENV_PASS}
  DBHOST=${DBHOST:-$DB_PORT_3306_TCP_ADDR}

  if [ -z "$DB_PORT_3306_TCP_ADDR" ]; then
	echo >&2 'error: missing MYSQL_PORT_3306_TCP environment variable'
	echo >&2 '  Did you forget to --link some_mysql_container:db ?'
	exit 1
  fi

  # Check if database already exists
  RESULT=`mysql -u${DBADMIN} -p${DBPASS} \
	-h${DBHOST} --skip-column-names \
	-e "SHOW DATABASES LIKE '${ETHERPAD_DB_NAME}'"`

  if [ "$RESULT" != $ETHERPAD_DB_NAME ]; then
	# mysql database does not exist, create it
	echo "Creating database ${ETHERPAD_DB_NAME}"

  mysql -u $DBADMIN --password=$DBPASS -h $DBHOST <<-EOF
      CREATE DATABASE IF NOT EXISTS ${ETHERPAD_DB_NAME} CHARACTER SET utf8;
      GRANT ALL PRIVILEGES ON ${ETHERPAD_DB_NAME}.* TO $ETHERPAD_DB_USER IDENTIFIED BY '$ETHERPAD_DB_PASS';
      FLUSH PRIVILEGES;
EOF

  fi

cat << EOF > settings.json
{
  "title": "${ETHERPAD_TITLE}",
  "ip": "0.0.0.0",
  "port" : 9001,
  "dbType" : "mysql",
  "dbSettings" : {
                    "user"    : "${ETHERPAD_DB_USER}", 
                    "host"    : "${DBHOST}", 
                    "password": "${ETHERPAD_DB_PASS}", 
                    "database": "${ETHERPAD_DB_NAME}"
                  },
EOF

cat << EOF >> settings.json
  "users": {
    "${ETHERPAD_ADMIN_USER}": {
      "password": "${ETHERPAD_ADMIN_PASS}",
      "is_admin": true
    }
  },
EOF

cat << EOF >> settings.json
}
EOF

echo " "
echo "---"
echo "APIKEY: $(cat /opt/etherpad-lite/APIKEY.txt)"
echo "ADMIN: $ETHERPAD_ADMIN_USER"
echo "ADMIN PASS: $ETHERPAD_ADMIN_PASS"
echo "---"
echo " "

rm /firstrun

fi

exit 0
