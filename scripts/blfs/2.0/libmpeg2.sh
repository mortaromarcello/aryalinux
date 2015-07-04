#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://libmpeg2.sourceforge.net/files/libmpeg2-0.5.1.tar.gz
wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/libmpeg2-0.5.1.tar.gz


TARBALL=libmpeg2-0.5.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's/static const/static/' libmpeg2/idct_mmx.c &&
./configure --prefix=/usr --disable-static          &&
make

cat > 1434987998835.sh << "ENDOFFILE"
make install &&
install -v -dm755 /usr/share/doc/mpeg2dec-0.5.1 &&
install -v -m644 README doc/libmpeg2.txt \
                    /usr/share/doc/mpeg2dec-0.5.1
ENDOFFILE
chmod a+x 1434987998835.sh
sudo ./1434987998835.sh
sudo rm -rf 1434987998835.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libmpeg2=>`date`" | sudo tee -a $INSTALLED_LIST