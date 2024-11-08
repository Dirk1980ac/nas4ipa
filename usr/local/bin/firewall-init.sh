#!/bin/sh
firewall-cmd --permanent --delete-zone=mesh

firewall-cmd --permanent --new-zone=mesh
firewall-cmd --permanent --zone=mesh --add-interface=tun0

firewall-cmd --permanent --new-zone=public
firewall-cmd --permanent --zone=public --add-service=dhcpv6-client
firewall-cmd --permanent --zone=public --add-service=mdns
firewall-cmd --permanent --zone=public --add-service=ssh

firewall-cmd --set-default-zone=public

firewall-cmd --reload
