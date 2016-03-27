#!/bin/bash
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
echo $crypted

SQL="UPDATE mail_user set password = '$crypted' WHERE email =  '$mail';"

echo ""
echo "Now we insert into db. you need to type the DB Root pwd"
result=$(docker exec -it mailstack-db mysql -p mailstack -e "$SQL")

if [[ $? == 0 ]]; then
	echo "EMail / User successful created"
else
	echo "Error occurred"
	echo "$result"
fi
