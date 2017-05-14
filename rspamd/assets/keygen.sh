#!/bin/bash
domain=$1

if [ -f "/dkim/$domain.default.key" ]; then
    >&2 echo "================================="
    >&2 echo "ABORT key exists $domain.default.key"
    >&2 echo "================================="
    >&2 echo "to generate a new key please delete key from the filesystem"
    exit 1
fi

result=$(rspamadm dkim_keygen -s 'default' -d '$domain' -k /dkim/$domain.default.key)
public=$(echo $result | cut -d "=" -f 4 | cut -d '"' -f 1)

>&2 echo "Add a TXT domain record for host: \"default._domainkey.$domain\" and value:"
>&2 echo "---------"
>&2 echo "v=DKIM1; k=rsa; p=$public"
>&2 echo "---------"

chown _rspamd:_rspamd -R /dkim
chmod 0600 /dkim/*
chmod 0700  /dkim