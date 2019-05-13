FROM krallin/ubuntu-tini:16.04
FROM hectormolinero/tini
MAINTAINER Seti <seti@setadesign.net>

ENV DEBIAN_FRONTEND noninteractive
ENV UBUNTU_NAME bionic

COPY assets/keygen.sh /
COPY assets/init.sh /init.sh

RUN mkdir /dkim /maps /run/rspamd && \
    apt-get update && apt-get dist-upgrade -y && apt-get install -y wget gnupg rsyslog dnsutils && \
    wget -O- https://rspamd.com/apt-stable/gpg.key | apt-key add - && \
    echo "deb http://rspamd.com/apt-stable/ $UBUNTU_NAME main" > /etc/apt/sources.list.d/rspamd.list && \
    echo "deb-src http://rspamd.com/apt-stable/ $UBUNTU_NAME main" >> /etc/apt/sources.list.d/rspamd.list && \
    apt-get update && \
    apt-get --no-install-recommends install -y rspamd && \
    apt-get remove gnupg -y && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    chmod 0755 /*.sh

COPY assets/conf/ /etc/rspamd/
COPY assets/rsyslog.conf /etc/rsyslog.conf

VOLUME ["/dkim", "/maps", "/var/lib/rspamd", "/etc/rspamd/local.d"]

EXPOSE 11332
EXPOSE 11333
EXPOSE 11334
CMD /init.sh
