#!/bin/bash 
set -x
cp /etc/tor/torrc /etc/tor/torrc_backup & 
set +x
sleep 3 &&
set -x
echo "
## Configuration file for a typical Tor user 
## Last updated 9 October 2013 for Tor 0.2.5.2-alpha. 
## (may or may not work for much older or much newer versions of Tor.) 
EntryNodes {af},{ax},{al},{dz},{ad},{ao},{ai},{aq},{ag},{ar},{am},{aw},{au},{at},{az},{bs},{bh},{bd},{bb},{by},{be},{bz},{bj},{bm},{bt},{bo},{ba},{bw},{bv},{br},{io},{vg},{bn},{bg},{bf},{bi},{kh},{cm},{ca},{cv},{ky},{cf} StrictNodes 1

#SocksPort 192.168.1.69:9050
#SocksPolicy accept 192.168.1.0/24
#RunAsDaemon 1
#DataDirectory /var/lib/tor
##

# Hidden service #1 is a web app that supports HTTP and HTTPS
HiddenServiceDir /var/lib/tor/webapp_service/
HiddenServicePort 80 127.0.0.1:80
HiddenServicePort 443 127.0.0.1:443

# Hidden service #2 will have a different .onion URL but
# still point to this same server.
HiddenServiceDir /var/lib/tor/ssh_service/
HiddenServicePort 22 127.0.0.1:22


ORPort 443
Exitpolicy reject *:*
Nickname ${LOGNAME}
" > /etc/tor/torrc

cp /etc/privoxy/config /etc/privoxy/config_backup &
set +x
sleep 6 &&
set -x 
echo "
# Generally, this file goes in /etc/privoxy/config
#
# Tor listens as a SOCKS4a proxy here:
forward-socks4a / 127.0.0.1:9050 .
forward-socks5 / 127.0.0.1:9050 . ###### in my case

confdir /etc/privoxy
logdir /var/log/privoxy
# actionsfile standard  # Internal purpose, recommended
actionsfile default.action   # Main actions file
actionsfile user.action      # User customizations
filterfile default.filter
 
# Don't log interesting things, only startup messages, warnings and errors
logfile logfile
#jarfile jarfile
#debug   0    # show each GET/POST/CONNECT request
debug   4096 # Startup banner and warnings
debug   8192 # Errors - *we highly recommended enabling this*
 
user-manual /usr/share/doc/privoxy/user-manual
listen-address  127.0.0.1:8118
toggle  1
enable-remote-toggle 0
enable-edit-actions 0
enable-remote-http-toggle 0
buffer-limit 4096

##########
forward-socks5 / localhost:9050 .
forward-socks4 / localhost:9050 .
forward-socks4a / localhost:9050 .

Configuring proxy services:
HTTP proxy: localhost:8118
SSL proxy: localhost:8118
SOCKS host: localhost:9050
" > /etc/privoxy/config
