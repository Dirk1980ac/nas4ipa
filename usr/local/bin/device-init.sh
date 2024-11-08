#!/bin/sh

if [ ! -f /var/lib/.init-done ]; then
	firewall-init.sh
fi
