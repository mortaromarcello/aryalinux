#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






cat > 1434987998780.sh << "ENDOFFILE"
cat > /etc/systemd/network/50-br0.netdev << EOF
[NetDev]
Name=<em class="replaceable"><code>br0</em>
Kind=bridge
EOF
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh

cat > 1434987998780.sh << "ENDOFFILE"
cat > /etc/systemd/network/51-eth0.network << EOF
[Match]
Name=<em class="replaceable"><code>eth0</em>

[Network]
Bridge=<em class="replaceable"><code>br0</em>
EOF
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh

cat > 1434987998780.sh << "ENDOFFILE"
cat > /etc/systemd/network/60-br0.network << EOF
[Match]
Name=<em class="replaceable"><code>br0</em>

DHCP=yes
EOF
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh

cat > 1434987998780.sh << "ENDOFFILE"
cat > /etc/systemd/network/60-br0.network << EOF
[Match]
Name=<em class="replaceable"><code>br0</em>

[Network]
Address=192.168.0.2/24
Gateway=192.168.0.1
DNS=192.168.0.1
EOF
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh

cat > 1434987998780.sh << "ENDOFFILE"
systemctl restart systemd-networkd
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh


 
cd $SOURCE_DIR
 
echo "advanced-network=>`date`" | sudo tee -a $INSTALLED_LIST