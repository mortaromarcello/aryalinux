#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gegl
#DEP:gtk2
#DEP:python-modules#pygtk


cd $SOURCE_DIR

wget -nc http://download.gimp.org/pub/gimp/v2.8/gimp-2.8.14.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/gimp-2.8.14-device_info-1.patch


TARBALL=gimp-2.8.14.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../gimp-2.8.14-device_info-1.patch

./configure --prefix=/usr --sysconfdir=/etc --without-gvfs &&
make

cat > 1434987998829.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh

ALL_LINGUAS="ca da de el en en_GB es fr it ja ko nl nn pt_BR ru sl sv zh_CN" \
./configure --prefix=/usr &&

make

cat > 1434987998829.sh << "ENDOFFILE"
gtk-update-icon-cache &&
update-desktop-database
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh

cat > 1434987998829.sh << "ENDOFFILE"
echo '(web-browser "firefox %s")' >> /etc/gimp/2.0/gimprc
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gimp=>`date`" | sudo tee -a $INSTALLED_LIST