#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/pub/gnu/cpio/cpio-2.11.tar.bz2
wget -nc ftp://ftp.gnu.org/pub/gnu/cpio/cpio-2.11.tar.bz2


TARBALL=cpio-2.11.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i -e '/gets is a/d' gnu/stdio.in.h &&
./configure --prefix=/usr \
            --bindir=/bin \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt &&
make &&
makeinfo --html            -o doc/html      doc/cpio.texi &&
makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi &&
makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi

cat > 1434987998771.sh << "ENDOFFILE"
make install &&
install -v -m755 -d /usr/share/doc/cpio-2.11/html &&
install -v -m644    doc/html/* \
                    /usr/share/doc/cpio-2.11/html &&
install -v -m644    doc/cpio.{html,txt} \
                    /usr/share/doc/cpio-2.11
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "cpio=>`date`" | sudo tee -a $INSTALLED_LIST