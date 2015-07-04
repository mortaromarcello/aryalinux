#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.musicbrainz.org/pub/musicbrainz/historical/libmusicbrainz-2.1.5.tar.gz
wget -nc ftp://ftp.musicbrainz.org/pub/musicbrainz/historical/libmusicbrainz-2.1.5.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/libmusicbrainz-2.1.5-missing-includes-1.patch


TARBALL=libmusicbrainz-2.1.5.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../libmusicbrainz-2.1.5-missing-includes-1.patch &&
./configure --prefix=/usr --disable-static &&
make

(cd python && python setup.py build)

cat > 1434987998835.sh << "ENDOFFILE"
make install &&
install -v -m644 -D docs/mb_howto.txt \
    /usr/share/doc/libmusicbrainz-2.1.5/mb_howto.txt
ENDOFFILE
chmod a+x 1434987998835.sh
sudo ./1434987998835.sh
sudo rm -rf 1434987998835.sh

cat > 1434987998835.sh << "ENDOFFILE"
(cd python && python setup.py install)
ENDOFFILE
chmod a+x 1434987998835.sh
sudo ./1434987998835.sh
sudo rm -rf 1434987998835.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libmusicbrainz=>`date`" | sudo tee -a $INSTALLED_LIST