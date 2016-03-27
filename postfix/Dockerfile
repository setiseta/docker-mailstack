FROM alpine
MAINTAINER Seti <seti@setadesign.net>

RUN apk add --update postfix postfix-mysql rsyslog bash mysql-client && \
	mkdir /mail && chmod 0750 /mail && \
#for testing and building  \
	apk add --update nano && \
#END for testing and building \
	rm -rf /vat/cache/apk/*

COPY assets/conf /etc/postfix
COPY assets/rsyslog.conf /etc/rsyslog.conf
COPY assets/init.sh /init.sh

RUN chmod 0644 "/etc/postfix/main.cf" && \
	chown root:root "/etc/postfix/main.cf" && \
	chmod 0640 "/etc/postfix/mysql-virtual_alias_maps.cf" && \
	chown root:postfix "/etc/postfix/mysql-virtual_alias_maps.cf" && \
	chmod 0640 "/etc/postfix/mysql-virtual_mailbox_domains.cf" && \
	chown root:postfix "/etc/postfix/mysql-virtual_mailbox_domains.cf" && \
	chmod 0640 "/etc/postfix/mysql-virtual_mailbox_maps.cf" && \
	chown root:postfix "/etc/postfix/mysql-virtual_mailbox_maps.cf" && \
	chmod 0755 /init.sh && \
	mv /var/spool/postfix /postfixtemplate

EXPOSE 25
EXPOSE 465
EXPOSE 587
VOLUME ["/var/spool/postfix/"]
CMD ["/init.sh"]
