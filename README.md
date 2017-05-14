Docker Mailstack
====

Mailstack based on docker images with dovecot, postfix, rmilter, rspamd

---
Last Changes
===
- Big config rework (14-05-2017):
  - DKIM Signing is done on rspamd now.
  - dkim folder needs to be mounted on rspamd now:
    - ```- ./data/dkim:/dkim```
  - Script add-domain.sh is updated to use rspamd container.

- Limit Configuration for Dovecot(06-05-2017):
  - example in docker-compose.yml on github repo
  - new environment Variables
    - PROCESSLIMIT default 100
    - CLIENTLIMIT default 500
- Added automx Container for Client auto Config.
 - if you update get first the automx.env and set it up for your env
 - add the automx part from the docker-compose.yml to your docker-compose.yml
 - need dns entry for:
   - autoconfig.yourdomain.tld
   - autodiscover.yourdomain.tld
- Add MAILBOX_FORMAT in env/config.env
 - Default: mdbox
 - Possible: maildir, mdbox, sdbox, mbox
 - Old Default: maildir(set this in your config.env if you already have set up the mailstack, and want to keep mails.)

---
Info
===
- questions/issues/pr/optimizations are welcome
- rspamd is not yet as configurable as it should be
 - maybe others too.

---
Requirements
===
- Docker / Docker-Engine installed:
 - https://docs.docker.com/engine/installation/
 - or from your distros repo if it has a new enough docker version
- Docker Compose installed(Version 1.6.2+):
 - https://docs.docker.com/compose/install/

---
Install & Management
===
- you can actually use the setup script and the other shell scripts to install & manage.
- it's intended to run with wilder/nginx-proxy and jrcs/letsencrypt-nginx-proxy-companion
 - cert path is set to /etc/ssl/docker
 - if your cert path is different, please change in docker-compose.yml and recreate (after setup script is run)
 - ```docker-compose down -v && docker-compose up -d```
---
Setup Script
===

```bash
curl -L https://raw.githubusercontent.com/setiseta/docker-mailstack/master/setup.sh -o setup.sh
chmod a+x setup.sh
./setup.sh
```

---
Manage Users & domains & passwords
===
- cause the admin web ui is not ready yet there are some shell scripts in the git repository.

### Add new Mailbox & Mailuser
- get the script: add-mailuser.sh
- run and follow instructions

```bash
curl https://raw.githubusercontent.com/setiseta/docker-mailstack/master/add-mailuser.sh -o add-mailuser.sh
chmod 0755 ./add-mailuser.sh
./add-mailuser.sh
```

### Add new Domain
- get the script: add-domain.sh
- run and follow instructions
- add the DNS key from the output to your DNS Server

```bash
curl https://raw.githubusercontent.com/setiseta/docker-mailstack/master/add-domain.sh -o add-domain.sh
chmod 0755 ./add-domain.sh
./add-domain.sh
```

### Update Mailuser Password
- get the script: mailuserpasswd.sh
- run and follow instructions

```bash
curl https://raw.githubusercontent.com/setiseta/docker-mailstack/master/mailuserpasswd.sh -o mailuserpasswd.sh
chmod 0755 ./mailuserpasswd.sh
./mailuserpasswd.sh
```

### Update Rspamd WebUI Password
- get the script: rspamdpasswd.sh
- run and follow instructions
- restart rspamd

```bash
curl https://raw.githubusercontent.com/setiseta/docker-mailstack/master/rspamdpasswd.sh -o rspamdpasswd.sh
chmod 0755 ./mailuserpasswd.sh
./mailuserpasswd.sh
docker-compose restart rspamd
```

### Postfix Startup Customizing
- map a init.custom.sh
- it will be executed befor anything is executed from the init.sh script
