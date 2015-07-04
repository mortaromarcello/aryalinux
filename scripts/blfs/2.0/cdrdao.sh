#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libao
#DEP:libvorbis
#DEP:libmad
#DEP:lame


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/cdrdao/cdrdao-1.2.3.tar.bz2


TARBALL=cdrdao-1.2.3.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i '/ioctl/a #include <sys/stat.h>' dao/ScsiIf-linux.cc &&

./configure --prefix=/usr --mandir=/usr/share/man &&
make

cat > 1434987998839.sh << "ENDOFFILE"
make install &&
install -v -dm755 /usr/share/doc/cdrdao-1.2.3 &&
install -v -m644 README /usr/share/doc/cdrdao-1.2.3
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "cdrdao=>`date`" | sudo tee -a $INSTALLED_LIST