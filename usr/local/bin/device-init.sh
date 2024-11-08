#!/bin/sh

if [ ! -f /etc/yggdrasil.conf ]; then
	yggdrasil -genconf -json > /etc/yggdrasil.generated.conf
	jq '.Peers = ["tls://ygg.yt:443","tls://ygg.mkg20001.io:443","tls://vpn.ltha.de:443","tls://ygg-uplink.thingylabs.io:443","tls://supergay.network:443","tls://[2a03:3b40:fe:ab::1]:993","tls://37.205.14.171:993"]' /etc/yggdrasil.generated.conf > /etc/yggdrasil.conf
	systemctl enable --now yggdrasil
	firewall-init.sh
fi
