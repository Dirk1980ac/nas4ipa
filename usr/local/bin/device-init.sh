#!/bin/bash

cat <<EOF >/etc/os-release
NAME="NAS3IPA"
VERSION="1"
ID="nas4ipa"
ID_LIKE="fedora"
VERSION_ID=1
PLATFORM_ID="platform:f41"
PRETTY_NAME="NAS4IPA 1"
ANSI_COLOR="0;34"
CPE_NAME="cpe:/o:Dirk1980ac:NAS4IPA:1"
DEFAULT_HOSTNAME="nas4ipa"
VARIANT="IoT Edition"
VARIANT_ID=iot
EOF
