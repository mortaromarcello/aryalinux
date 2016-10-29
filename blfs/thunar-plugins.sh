#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="thunar-plugins"
VERSION="0.4.1"

#REQ:xfce4-dev-tools
#REQ:thunar


cd $SOURCE_DIR

wget -nc http://archive.ubuntu.com/ubuntu/pool/universe/t/thunar-archive-plugin/thunar-archive-plugin_0.3.1.orig.tar.bz2
wget -nc http://ftp.mirrorservice.org/sites/download.salixos.org/i486/13.1/source/xap/thunar-thumbnailers/thunar-thumbnailers-0.4.1.tar.bz2

TARBALL=thunar-archive-plugin_0.3.1.orig.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr \
            --sysconfdir=/etc &&
make

cat > 1434987998824.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998824.sh
sudo ./1434987998824.sh
sudo rm -rf 1434987998824.sh


cd $SOURCE_DIR

TARBALL=thunar-thumbnailers-0.4.1.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr \
            --sysconfdir=/etc &&
make

cat > 1434987998824.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998824.sh
sudo ./1434987998824.sh
sudo rm -rf 1434987998824.sh


 
cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"
 
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
