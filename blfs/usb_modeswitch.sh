#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

wget -nc http://www.draisberghof.de/usb_modeswitch/usb-modeswitch-2.2.5.tar.bz2
wget -nc http://www.draisberghof.de/usb_modeswitch/usb-modeswitch-data-20150627.tar.bz2

tar -xf usb-modeswitch-2.2.5.tar.bz2
cd usb-modeswitch-2.2.5

sudo make install-static

cd $SOURCE_DIR
rm -rf usb-modeswitch-2.2.5


tar -xf usb-modeswitch-data-20150627.tar.bz2
cd usb-modeswitch-data-20150627

sudo make install

cd $SOURCE_DIR
rm -rf usb-modeswitch-data-20150627

echo "usb_modeswitch=>`date`" | sudo tee -a $INSTALLED_LIST
