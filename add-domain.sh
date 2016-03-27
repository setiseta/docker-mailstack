#!/bin/bash
source ./env/db.env
if [ -z "$1" ]; then
	echo "---------------------------------------"
	echo "Add new Domain and generate dkim key"
	echo "---------------------------------------"
	read -p "Domain: " domain
	echo ""
else
	domain=$1
fi

if [ -z "$domain" ]; then
	echo "Domain is needed"
	exit 1
fi

result=$(docker exec -it mailstack-rmilter /keygen.sh "$domain")
status=$?
echo "$result"

if [ "$status" == "1" ]; then
	exit 1
fi

SQL="INSERT INTO domains (domain, dkimdns, isemaildomain) VALUES ('$domain', '$result', 1)"

echo ""
#echo "Now we insert into db. you need to type the DB Root pwd"
docker exec -it mailstack-db mysql -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE -e "$SQL"
