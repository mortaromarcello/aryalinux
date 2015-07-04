#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:yasm
#DEP:gtk2
#DEP:libvdpau


cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/sources/other/mplayer-2014-12-19.tar.xz


TARBALL=mplayer-2014-12-19.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's:libsmbclient.h:samba-4.0/&:' configure stream/stream_smb.c &&

./configure --prefix=/usr            \
            --confdir=/etc/mplayer   \
            --enable-dynamic-plugins \
            --enable-menu            \
            --enable-gui             &&
make

make doc

cat > 1434987998839.sh << "ENDOFFILE"
make install  &&
ln -svf ../icons/hicolor/48x48/apps/mplayer.png \
        /usr/share/pixmaps/mplayer.png
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh

cat > 1434987998839.sh << "ENDOFFILE"
install -v -m755 -d /usr/share/doc/mplayer-2014-12-19 &&
install -v -m644    DOCS/HTML/en/* \
                    /usr/share/doc/mplayer-2014-12-19
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh

cat > 1434987998839.sh << "ENDOFFILE"
install -v -m644 etc/codecs.conf /etc/mplayer
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh

cat > 1434987998839.sh << "ENDOFFILE"
install -v -m644 etc/*.conf /etc/mplayer
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh

cat > 1434987998839.sh << "ENDOFFILE"
gtk-update-icon-cache &&
update-desktop-database
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh

cat > 1434987998839.sh << "ENDOFFILE"
tar -xvf  ../Clearlooks-1.6.tar.bz2 \
    -C    /usr/share/mplayer/skins &&
ln  -sfvn Clearlooks /usr/share/mplayer/skins/default
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "mplayer=>`date`" | sudo tee -a $INSTALLED_LIST