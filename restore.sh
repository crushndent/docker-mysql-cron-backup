#!/bin/bash

# Get hostname: try read from file, else get from env
[ -z "${MYSQL_HOST_FILE}" ] || { MYSQL_HOST=$(head -1 "${MYSQL_HOST_FILE}"); }
[ -z "${MYSQL_HOST}" ] && { echo "=> MYSQL_HOST cannot be empty" && exit 1; }
# Get username: try read from file, else get from env
[ -z "${MYSQL_USER_FILE}" ] || { MYSQL_USER=$(head -1 "${MYSQL_USER_FILE}"); }
[ -z "${MYSQL_USER}" ] && { echo "=> MYSQL_USER cannot be empty" && exit 1; }
# Get password: try read from file, else get from env, else get from MYSQL_PASSWORD env
[ -z "${MYSQL_PASS_FILE}" ] || { MYSQL_PASS=$(head -1 "${MYSQL_PASS_FILE}"); }
[ -z "${MYSQL_PASS:=$MYSQL_PASSWORD}" ] && { echo "=> MYSQL_PASS cannot be empty" && exit 1; }

if [ "$#" -ne 1 ]
then
    echo "You must pass the path of the backup file to restore"
    exit 1
fi

set -o pipefail

if [ -z "${USE_PLAIN_SQL}" ]
then
    SQL=$(gunzip -c "$1")
else
    SQL=$(cat "$1")
fi


if echo "$SQL" | mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASS" $MYSQL_SSL_OPTS 
then
    echo "=> Restore succeeded"
else
    echo "=> Restore failed"
fi
