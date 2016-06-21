FROM ubuntu:16.04
MAINTAINER Seti <seti@setadesign.net>

ENV DEBIAN_FRONTEND noninteractive
ENV UBUNTU_NAME xenial

COPY assets/init.sh /init.sh
RUN apt-get update && apt-get install -y wget rsyslog && \
    wget -O- https://rspamd.com/apt-stable/gpg.key | apt-key add - && \
    echo "deb http://rspamd.com/apt-stable/ $UBUNTU_NAME main" > /etc/apt/sources.list.d/rspamd.list && \
    echo "deb-src http://rspamd.com/apt-stable/ $UBUNTU_NAME main" >> /etc/apt/sources.list.d/rspamd.list && \
    apt-get update && \
    apt-get --no-install-recommends install -y rspamd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    chmod 0755 /init.sh

COPY assets/conf/ /etc/rspamd/

EXPOSE 11333
EXPOSE 11334
CMD /init.sh; rspamd -u _rspamd -g _rspamd; rsyslogd -n
