- RMilter is now not used anymore (15-06-2017)

- Big config rework (14-05-2017):
  - DKIM Signing is done on rspamd now.
  - dkim folder needs to be mounted on rspamd now:
    - ```- ./data/dkim:/dkim```
  - Script add-domain.sh is updated to use rspamd container.
  - move whitelist.map in config/maps/ to greylist-ip-whitelist.map

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