#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://ftp.mutt.org/mutt/mutt-1.5.23.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/mutt-1.5.23-upstream_fixes-1.patch


TARBALL=mutt-1.5.23.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998786.sh << "ENDOFFILE"
groupadd -g 34 mail
ENDOFFILE
chmod a+x 1434987998786.sh
sudo ./1434987998786.sh
sudo rm -rf 1434987998786.sh

cat > 1434987998786.sh << "ENDOFFILE"
chgrp -v mail /var/mail
ENDOFFILE
chmod a+x 1434987998786.sh
sudo ./1434987998786.sh
sudo rm -rf 1434987998786.sh

patch -Np1 -i ../mutt-1.5.23-upstream_fixes-1.patch &&
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-docdir=/usr/share/doc/mutt-1.5.23 \
            --enable-pop      \
            --enable-imap     \
            --enable-hcache   \
            --without-qdbm    \
            --with-gdbm       \
            --without-bdb     \
            --without-tokyocabinet &&
make

cat > 1434987998786.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998786.sh
sudo ./1434987998786.sh
sudo rm -rf 1434987998786.sh

cat /usr/share/doc/mutt-1.5.23/samples/gpg.rc >> ~/.muttrc


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "mutt=>`date`" | sudo tee -a $INSTALLED_LIST