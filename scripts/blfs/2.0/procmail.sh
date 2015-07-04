#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.ring.gr.jp/archives/net/mail/procmail/procmail-3.22.tar.gz
wget -nc ftp://ftp.ucsb.edu/pub/mirrors/procmail/procmail-3.22.tar.gz


TARBALL=procmail-3.22.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998786.sh << "ENDOFFILE"
sed -i 's/getline/get_line/' src/*.[ch] &&
make LOCKINGTEST=/tmp MANDIR=/usr/share/man install &&
make install-suid
ENDOFFILE
chmod a+x 1434987998786.sh
sudo ./1434987998786.sh
sudo rm -rf 1434987998786.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "procmail=>`date`" | sudo tee -a $INSTALLED_LIST