#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gs
#DEP:x7lib
#DEP:libxcb
#DEP:installing
#DEP:epdfview
#DEP:
#DEP:glu
#DEP:readline-5.2.tar.gz
#DEP:python2
#DEP:ruby


cd $SOURCE_DIR

wget -nc http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz


TARBALL=install-tl-unx.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998843.sh << "ENDOFFILE"
TEXLIVE_INSTALL_PREFIX=/opt/texlive ./install-tl
ENDOFFILE
chmod a+x 1434987998843.sh
sudo ./1434987998843.sh
sudo rm -rf 1434987998843.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "tl-installer=>`date`" | sudo tee -a $INSTALLED_LIST