#!/bin/bash
source ./env/db.env
if [[ -z "$1" || -z "$2" ]]; then
	echo "---------------------------------------"
	echo "This script updates password of existing mailbox"
	echo "EMail address is the same as the username"
	echo "---------------------------------------"
	read -p "EMail: " mail
	read -s -p "Password: " pwd
	echo ""
else
	mail=$1
	pwd=$2
fi

if [[ $mail == "" || $pwd == "" ]]; then
	echo "Error---"
	echo "EMail & Password is needed"
	exit 1
fi

pwdcrypted=$(docker exec -it mailstack-dovecot doveadm pw -s SHA512-CRYPT -p $pwd)
crypted=$(echo "$pwdcrypted" | tr -d $'\r' | cat -v)

SQL="UPDATE mail_user set password = '$crypted' WHERE email =  '$mail';"

echo ""
{
	result=$(docker exec -it mailstack-db mysql -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE -e "$SQL")
} &> /dev/null

if [[ $? == 0 ]]; then
	echo "Pwd updated"
else
	echo "Error occurred"
	echo "$result"
fi
