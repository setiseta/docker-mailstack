#!/bin/bash
#cp -f /etc/rspamd/rspamd.tmpl /etc/rspamd/rspamd.conf
# Substitute configuration
#for VARIABLE in `env | cut -f1 -d=`; do
#  sed -i "s={{ $VARIABLE }}=${!VARIABLE}=g" /etc/rspamd/*.conf
#done

echo "password = \"$RSPAMD_PWD\";" > /etc/rspamd/local.d/worker-controller.inc
echo "enable_password = \"$RSPAMD_PWDADMIN\";" >> /etc/rspamd/local.d/worker-controller.inc

rm -f /var/run/rsyslogd.pid
