FROM alpine
MAINTAINER Seti <seti@setadesign.net>

COPY assets/init.sh /init.sh
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	echo "@community http://dl-3.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
	apk add --update \
		dovecot bash \
		dovecot-mysql mysql-client \
		dovecot-pigeonhole-plugin@community \
		dovecot-antispam-plugin@testing && \
	rm -rf /var/cache/apk/* && \
	chmod 0755 /init.sh

COPY assets/conf /etc/dovecot
COPY assets/sieve /var/lib/dovecot

EXPOSE 143
EXPOSE 993

CMD ["/init.sh"]
