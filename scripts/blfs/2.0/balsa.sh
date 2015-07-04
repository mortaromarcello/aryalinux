#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gmime
#DEP:gtk2
#DEP:gtk3
#DEP:enchant
#DEP:
#DEP:libesmtp
#DEP:libnotify
#DEP:pcre
#DEP:webkitgtk2
#DEP:gtkhtml


cd $SOURCE_DIR

wget -nc http://pawsa.fedorapeople.org/balsa/balsa-2.5.1.tar.bz2


TARBALL=balsa-2.5.1.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998829.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "balsa=>`date`" | sudo tee -a $INSTALLED_LIST