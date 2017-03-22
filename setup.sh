#!/bin/bash
echo "==============================="
echo "Setup seti's docker mailstack"
echo "==============================="
echo "jwilder/nginx-proxy with jrcs/letsencrypt-nginx-proxy-companion is needed"
echo "setup not yet implemented here"
#read -n 1 -p "Should I setup it for you:(y/N) " setupnginx
echo "-------------------------------"
read -p "First/Main domain: " MAIN_DOMAIN
read -p "Mailserver hostname (eg. mail.example.com): " HOSTNAME
read -p "MAILBOX_FORMAT(mdbox): " MAILBOX_FORMAT
echo "-------------------------------"
echo "DB Container Setup"
read -p "MySQL Root pw: " MYSQL_ROOT_PASSWORD
read -p "MySQL User:(mailstack) " MYSQL_USER
read -p "MySQL User pw: " MYSQL_PASSWORD
read -p "MySQL Database:(mailstack) " MYSQL_DATABASE
echo "-------------------------------"
echo "Rspamd WebUI Setup"
read -p "Letsencrypt Email: " LETSENCRYPT_EMAIL
read -p "Rspamd User pw: " rspamuserpw
read -p "Rspamd Admin pw: " rspamadminpw
echo "-------------------------------"
echo "First Mail Setup"
echo "Username / Email: postmaster@$MAIN_DOMAIN"
read -p "Password: " postmasterpw
echo "-------------------------------"
echo ""
echo "Start setup process:"
echo "Setup uses actual directory."
read -n 1 -p "Continue: (Y/n)" start

start=$( echo "$start" | awk '{print tolower($0)}' )
if [[ "$start" == "n" ]]; then
    echo "aborting.."
    exit 1
fi

if [[ "$MAILBOX_FORMAT" == "" ]]; then
    MAILBOX_FORMAT="mdbox"
fi

if [[ "$MYSQL_USER" == "" ]]; then
    MYSQL_USER="mailstack"
fi
if [[ "$MYSQL_DATABASE" == "" ]]; then
    MYSQL_DATABASE="mailstack"
fi

echo "downloading files..."
{
    mkdir env
    curl https://raw.githubusercontent.com/setiseta/docker-mailstack/master/env/automx.env -o env/automx.env
    curl https://raw.githubusercontent.com/setiseta/docker-mailstack/master/env/config.env -o env/config.env
    curl https://raw.githubusercontent.com/setiseta/docker-mailstack/master/env/db.env -o env/db.env
    curl https://raw.githubusercontent.com/setiseta/docker-mailstack/master/env/dbconnection.env -o env/dbconnection.env
    curl https://raw.githubusercontent.com/setiseta/docker-mailstack/master/env/rspamd.env -o env/rspamd.env
    curl https://raw.githubusercontent.com/setiseta/docker-mailstack/master/docker-compose.yml -o docker-compose.yml
    curl https://raw.githubusercontent.com/setiseta/docker-mailstack/master/rspamdpasswd.sh -o rspamdpasswd.sh
    curl https://raw.githubusercontent.com/setiseta/docker-mailstack/master/add-domain.sh -o add-domain.sh
    curl https://raw.githubusercontent.com/setiseta/docker-mailstack/master/add-mailuser.sh -o add-mailuser.sh
    curl https://raw.githubusercontent.com/setiseta/docker-mailstack/master/mailuserpasswd.sh -o mailuserpasswd.sh

    chmod 0755 ./*.sh
} &> /dev/null

echo "generating rspamd password hashes"
{
    docker-compose up -d redis rspamd
    RSPAMD_PWD=$( docker exec -it mailstack-rspamd rspamadm pw --encrypt -p $rspamuserpw )
    RSPAMD_PWDADMIN=$( docker exec -it mailstack-rspamd rspamadm pw --encrypt -p $rspamadminpw )
    docker-compose down -v

    export MAIN_DOMAIN HOSTNAME MAILBOX_FORMAT MYSQL_ROOT_PASSWORD MYSQL_USER MYSQL_PASSWORD MYSQL_DATABASE LETSENCRYPT_EMAIL RSPAMD_PWD RSPAMD_PWDADMIN

    for VARIABLE in `env | cut -f1 -d=`; do
        sed -i "s={{ $VARIABLE }}=${!VARIABLE}=g" ./env/*.env
        sed -i "s={{ $VARIABLE }}=${!VARIABLE}=g" ./docker-compose.yml
    done

} &> /dev/null

echo "generate db schema"
docker-compose up -d mysql
prog="docker exec -it mailstack-db mysqladmin -p$MYSQL_ROOT_PASSWORD status"
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
{
    curl -L https://raw.githubusercontent.com/setiseta/docker-mailstack/master/structure.sql -o ./data/mysql/structure.sql
    docker exec -it mailstack-db bash -c "mysql -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /var/lib/mysql/structure.sql"
} &> /dev/null

echo ""
echo "starting mailstack..."
docker-compose up -d

echo ""
echo "Setup first domain"
./add-domain.sh $MAIN_DOMAIN
read -p "it's important to set this DNS entry. Continue with return." dkimpub

echo ""
echo "Setup Mailbox: postmaster@$MAIN_DOMAIN"
./add-mailuser.sh postmaster@$MAIN_DOMAIN $postmasterpw

echo ""
echo "setup complete"
echo "==============================="
echo "Config infos:"
echo "IMAP & SMTP Server: $HOSTNAME"
echo "Username: postmaster@$MAIN_DOMAIN (full email address)"
echo "Rspamd WebUI: https://$HOSTNAME"
echo "-------------------------------"
