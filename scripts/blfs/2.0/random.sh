#!/bin/bash

set -e
set +h

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






cat > 1434309266621.sh << ENDOFFILE
make install-random
ENDOFFILE
chmod a+x 1434309266621.sh
sudo ./1434309266621.sh
sudo rm -rf 1434309266621.sh


 
cd $SOURCE_DIR
 
echo "random=>`date`" | sudo tee -a $INSTALLED_LIST