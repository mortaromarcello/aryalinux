#!/bin/bash

set -e
set +h

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2


cd $SOURCE_DIR

TARBALL=eudev
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

wget -nc http://dev.gentoo.org/~blueness/eudev


tar -xf $TARBALL

cd $DIRECTORY

sed -r -i 's|/usr(/bin/test)|\1|'         test/udev-test.pl  &&

./configure --prefix=/usr           \
            --bindir=/sbin          \
            --sbindir=/sbin         \
            --libdir=/usr/lib       \
            --sysconfdir=/etc       \
            --libexecdir=/lib       \
            --with-rootprefix=      \
            --with-rootlibdir=/lib  \
            --enable-split-usr      \
            --enable-libkmod        \
            --enable-rule_generator \
            --enable-keymap         \
            --disable-introspection \
            --disable-gtk-doc-html  \
            --with-firmware-path=/lib/firmware &&

make

cat > 1434309266713.sh << ENDOFFILE
make install
ENDOFFILE
chmod a+x 1434309266713.sh
sudo ./1434309266713.sh
sudo rm -rf 1434309266713.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "udev-extras=>`date`" | sudo tee -a $INSTALLED_LIST