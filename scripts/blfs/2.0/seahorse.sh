#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gcr
#DEP:gnupg
#DEP:gpgme
#DEP:gtk3
#DEP:itstool
#DEP:libsecret
#DEP:libsoup
#DEP:openssh
#DEP:vala
#DEP:gnome-keyring


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/seahorse/3.14/seahorse-3.14.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/seahorse/3.14/seahorse-3.14.0.tar.xz


TARBALL=seahorse-3.14.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998822.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998822.sh
sudo ./1434987998822.sh
sudo rm -rf 1434987998822.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "seahorse=>`date`" | sudo tee -a $INSTALLED_LIST