#!/bin/bash
source ./env/db.env
echo "---------------------------------------"
echo "This script generates a new mail user / mailbox"
echo "EMail address is the same as the username"
echo "---------------------------------------"
read -p "EMail: " mail
read -s -p "Password: " pwd
echo ""

if [[ $mail == "" || $pwd == "" ]]; then
	echo "Error---"
	echo "EMail & Password is needed"
	exit 1
fi

crypted=$(docker exec -it mailstack-dovecot doveadm pw -s SHA512-CRYPT -p $pwd)
#crypted=${pwdcrypted#\{SHA512-CRYPT\}}
crypted=$(echo "$pwdcrypted" | xargs)

SQL="UPDATE mail_user set password = '$crypted' WHERE email =  '$mail';"

echo ""
echo "Now we insert into db. you need to type the DB Root pwd"
result=$(docker exec -it mailstack-db mysql -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE -e "$SQL")

if [[ $? == 0 ]]; then
	echo "EMail / User successful created"
else
	echo "Error occurred"
	echo "$result"
fi
