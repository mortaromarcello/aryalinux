#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions




cd $SOURCE_DIR


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/systemd/network/50-br0.netdev << EOF
[NetDev]
Name=<em class="replaceable"><code>br0</em>
Kind=bridge
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/systemd/network/51-eth0.network << EOF
[Match]
Name=<em class="replaceable"><code>eth0</em>
[Network]
Bridge=<em class="replaceable"><code>br0</em>
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/systemd/network/60-br0.network << EOF
[Match]
Name=<em class="replaceable"><code>br0</em>
[Network]
DHCP=yes
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/systemd/network/60-br0.network << EOF
[Match]
Name=<em class="replaceable"><code>br0</em>
[Network]
Address=192.168.0.2/24
Gateway=192.168.0.1
DNS=192.168.0.1
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl restart systemd-networkd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "advanced-network=>`date`" | sudo tee -a $INSTALLED_LIST

