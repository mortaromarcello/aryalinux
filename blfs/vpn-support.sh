#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:vpnc
#REQ:network-manager-vpnc
#REQ:pptp-linux
#REQ:network-manager-pptp
#REQ:openconnect
#REQ:network-manager-openconnect
#REQ:openvpn
#REQ:network-manager-openvpn

echo "vpn-support=>`date`" | sudo tee -a $INSTALLED_LIST
