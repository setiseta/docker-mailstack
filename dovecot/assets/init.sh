#!/bin/bash
if [[ "$MAILBOX_FORMAT" == "" ]]; then
    MAILBOX_FORMAT="mdbox"
	export MAILBOX_FORMAT
fi
#DB Setup
DB_TYPE=${DB_TYPE:-}
DB_HOST=${DB_HOST:-}
DB_PORT=${DB_PORT:-}
DB_NAME=${DB_NAME:-}
DB_USER=${DB_USER:-}
DB_PASS=${DB_PASS:-}

if [ -n "${MYSQL_PORT_3306_TCP_ADDR}" ]; then
	DB_TYPE=${DB_TYPE:-mysql}
	DB_HOST=${DB_HOST:-${MYSQL_PORT_3306_TCP_ADDR}}
	DB_PORT=${DB_PORT:-${MYSQL_PORT_3306_TCP_PORT}}

	# support for linked sameersbn/mysql image
	DB_USER=${DB_USER:-${MYSQL_ENV_DB_USER}}
	DB_PASS=${DB_PASS:-${MYSQL_ENV_DB_PASS}}
	DB_NAME=${DB_NAME:-${MYSQL_ENV_DB_NAME}}

	# support for linked orchardup/mysql and enturylink/mysql image
	# also supports official mysql image
	DB_USER=${DB_USER:-${MYSQL_ENV_MYSQL_USER}}
	DB_PASS=${DB_PASS:-${MYSQL_ENV_MYSQL_PASSWORD}}
	DB_NAME=${DB_NAME:-${MYSQL_ENV_MYSQL_DATABASE}}
fi

if [ -z "${DB_HOST}" ]; then
  echo "ERROR: "
  echo "  Please configure the database connection."
  echo "  Cannot continue without a database. Aborting..."
  exit 1
fi

# use default port number if it is still not set
case "${DB_TYPE}" in
  mysql) DB_PORT=${DB_PORT:-3306} ;;
  *)
    echo "ERROR: "
    echo "  Please specify the database type in use via the DB_TYPE configuration option."
    echo "  Accepted value \"mysql\". Aborting..."
    exit 1
    ;;
esac

export DB_TYPE
export DB_HOST
export DB_PORT
export DB_NAME
export DB_USER
export DB_PASS

# wait for db to get ready
prog="mysqladmin -h ${DB_HOST} -P ${DB_PORT} -u ${DB_USER} ${DB_PASS:+-p$DB_PASS} status"
timeout=60
echo "Waiting for database server to accept connections"
while ! ${prog} >/dev/null 2>&1
do
	timeout=$(expr $timeout - 1)
	if [ $timeout -eq 0 ]; then
		printf "\nCould not connect to database server. Aborting...\n"
		exit 1
	fi
	printf "."
	sleep 1
done
echo "DB onnection is ok"

cp -rf /etc/dovecottemplate/* /etc/dovecot/
# Substitute configuration
for VARIABLE in `env | cut -f1 -d=`; do
	sed -i "s={{ $VARIABLE }}=${!VARIABLE}=g" /etc/dovecot/*.conf
	sed -i "s={{ $VARIABLE }}=${!VARIABLE}=g" /etc/dovecot/*.ext
done


# Fix permissions
chown -R mail:mail /mail
chown -R mail:mail /var/lib/dovecot

# Run dovecot
exec /usr/sbin/dovecot -c /etc/dovecot/dovecot.conf -F
