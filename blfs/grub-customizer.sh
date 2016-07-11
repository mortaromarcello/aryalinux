#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:grub-customizer:5.0.6

cd $SOURCE_DIR

wget -nc https://launchpad.net/grub-customizer/5.0/5.0.6/+download/grub-customizer_5.0.6.tar.gz
tar xf grub-customizer_5.0.6.tar.gz
cd grub-customizer-5.0.6

cmake -DCMAKE_INSTALL_PREFIX=/usr
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf grub-customizer-5.0.6

echo "grub-customizer=>`date`" | sudo tee -a $INSTALLED_LIST


