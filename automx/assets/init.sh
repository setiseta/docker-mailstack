#!/bin/bash
# Substitute configuration
for VARIABLE in `env | cut -f1 -d=`; do
	sed -i "s={{ $VARIABLE }}=${!VARIABLE}=g" /etc/apache2/sites-enabled/*.conf
	sed -i "s={{ $VARIABLE }}=${!VARIABLE}=g" /etc/automx.conf
done

apache2ctl -D FOREGROUND
