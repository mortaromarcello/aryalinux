#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:python-modules#pygobject2
#DEP:atk
#DEP:pango
#DEP:python-modules#py2cairo
#DEP:pango
#DEP:python-modules#py2cairo
#DEP:gtk2
#DEP:python-modules#py2cairo
#DEP:libglade


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2


TARBALL=pygtk-2.24.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make


cat > 1434987998777.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998777.sh
sudo ./1434987998777.sh
sudo rm -rf 1434987998777.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "python-modules#pygtk=>`date`" | sudo tee -a $INSTALLED_LIST