#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/gnu/screen/screen-4.2.1.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/screen/screen-4.2.1.tar.gz


TARBALL=screen-4.2.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr                     \
            --infodir=/usr/share/info         \
            --mandir=/usr/share/man           \
            --with-socket-dir=/run/screen     \
            --with-pty-group=5                \
            --with-sys-screenrc=/etc/screenrc &&

sed -i -e "s%/usr/local/etc/screenrc%/etc/screenrc%" {etc,doc}/* &&
make

cat > 1434987998769.sh << "ENDOFFILE"
make install &&
install -v -m644 etc/etcscreenrc /etc/screenrc
ENDOFFILE
chmod a+x 1434987998769.sh
sudo ./1434987998769.sh
sudo rm -rf 1434987998769.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "screen=>`date`" | sudo tee -a $INSTALLED_LIST