#!/bin/bash
domain=$1

if [ -f "/dkimkeys/$domain.default.key" ]; then
    >&2 echo "================================="
    >&2 echo "ABORT key exists $domain.default.key"
    >&2 echo "================================="
    >&2 echo "to generate a new key please delete key from the filesystem"
    exit 1
fi

>&2 opendkim-genkey -d "$domain"
>&2 echo "Add a TXT domain record for host: \"default._domainkey.$domain\" and value:"
>&2 echo "---------"
>&2 echo $(cat default.txt | cut -d "(" -f2 | cut -d ")" -f1 | sed 's/[[:space:]]*//' | sed ':a;N;$!ba;s/\n//g' | sed 's/\"//g')
>&2 echo "---------"
rm default.txt

mv default.private /dkimkeys/$domain.default.key
chown opendkim:opendkim -R /dkimkeys
chmod 0600 -R /dkimkeys
