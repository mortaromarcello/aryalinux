#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:boost
#DEP:gnome-icon-theme
#DEP:gtk2
#DEP:opal
#DEP:dbus-glib
#DEP:GConf
#DEP:libnotify


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/ekiga/4.0/ekiga-4.0.1.tar.xz


TARBALL=ekiga-4.0.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-eds     \
            --disable-gdu     \
            --disable-ldap    \
            --disable-scrollkeeper &&
make

cat > 1434987998829.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "ekiga=>`date`" | sudo tee -a $INSTALLED_LIST