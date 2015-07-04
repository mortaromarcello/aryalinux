#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/gnu/enscript/enscript-1.6.6.tar.gz
wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/enscript-1.6.6.tar.gz


TARBALL=enscript-1.6.6.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr              \
            --sysconfdir=/etc/enscript \
            --localstatedir=/var       \
            --with-media=Letter &&
make &&

pushd docs &&
  makeinfo --plaintext -o enscript.txt enscript.texi &&
popd

cat > 1434987998843.sh << "ENDOFFILE"
make install &&

install -v -m755 -d /usr/share/doc/enscript-1.6.6 &&
install -v -m644    README* *.txt docs/*.txt \
                    /usr/share/doc/enscript-1.6.6
ENDOFFILE
chmod a+x 1434987998843.sh
sudo ./1434987998843.sh
sudo rm -rf 1434987998843.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "enscript=>`date`" | sudo tee -a $INSTALLED_LIST