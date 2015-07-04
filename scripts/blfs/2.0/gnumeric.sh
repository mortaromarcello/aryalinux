#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:goffice010
#DEP:rarian
#DEP:adwaita-icon-theme
#DEP:oxygen-icons
#DEP:gnome-icon-theme
#DEP:installing
#DEP:yelp


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnumeric/1.12/gnumeric-1.12.20.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnumeric/1.12/gnumeric-1.12.20.tar.xz


TARBALL=gnumeric-1.12.20.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -e "s@zz-application/zz-winassoc-xls;@@" -i gnumeric.desktop.in &&
./configure --prefix=/usr &&
make

cat > 1434987998827.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998827.sh
sudo ./1434987998827.sh
sudo rm -rf 1434987998827.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnumeric=>`date`" | sudo tee -a $INSTALLED_LIST