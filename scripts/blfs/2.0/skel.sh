#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






cat > 1434987998743.sh << "ENDOFFILE"
useradd -m <em class="replaceable"><code><newuser></em>
ENDOFFILE
chmod a+x 1434987998743.sh
sudo ./1434987998743.sh
sudo rm -rf 1434987998743.sh


 
cd $SOURCE_DIR
 
echo "skel=>`date`" | sudo tee -a $INSTALLED_LIST