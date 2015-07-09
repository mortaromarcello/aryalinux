#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/pub/gnu/emacs/emacs-24.4.tar.xz
wget -nc ftp://ftp.gnu.org/pub/gnu/emacs/emacs-24.4.tar.xz


TARBALL=emacs-24.4.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr         \
            --with-gif=no         \
            --localstatedir=/var  &&
make bootstrap

cat > 1434987998753.sh << "ENDOFFILE"
make install &&
chown -v -R root:root /usr/share/emacs/24.4
ENDOFFILE
chmod a+x 1434987998753.sh
sudo ./1434987998753.sh
sudo rm -rf 1434987998753.sh

cat > 1434987998753.sh << "ENDOFFILE"
gtk-update-icon-cache -qf /usr/share/icons/hicolor
ENDOFFILE
chmod a+x 1434987998753.sh
sudo ./1434987998753.sh
sudo rm -rf 1434987998753.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "emacs=>`date`" | sudo tee -a $INSTALLED_LIST