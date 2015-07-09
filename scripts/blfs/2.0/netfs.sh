#!/bin/bash

set -e
set +h

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






cat > 1434309266734.sh << ENDOFFILE
make install-netfs
ENDOFFILE
chmod a+x 1434309266734.sh
sudo ./1434309266734.sh
sudo rm -rf 1434309266734.sh


 
cd $SOURCE_DIR
 
echo "netfs=>`date`" | sudo tee -a $INSTALLED_LIST