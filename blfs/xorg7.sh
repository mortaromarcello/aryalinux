#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions




cd $SOURCE_DIR

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

mkdir xc &&
cd xc


export XORG_PREFIX="<em class="replaceable"><code><PREFIX></em>"


export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"


cat > /etc/profile.d/xorg.sh << "EOF"
XORG_PREFIX="<em class="replaceable"><code><PREFIX></em>"
XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
export XORG_PREFIX XORG_CONFIG
EOF
chmod 644 /etc/profile.d/xorg.sh


cat >> /etc/profile.d/xorg.sh << "EOF"
pathappend $XORG_PREFIX/bin             PATH
pathappend $XORG_PREFIX/lib/pkgconfig   PKG_CONFIG_PATH
pathappend $XORG_PREFIX/share/pkgconfig PKG_CONFIG_PATH
pathappend $XORG_PREFIX/lib             LIBRARY_PATH
pathappend $XORG_PREFIX/include         C_INCLUDE_PATH
pathappend $XORG_PREFIX/include         CPLUS_INCLUDE_PATH
ACLOCAL='aclocal -I $XORG_PREFIX/share/aclocal'
export PATH PKG_CONFIG_PATH ACLOCAL LIBRARY_PATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
EOF


echo "$XORG_PREFIX/lib" >> /etc/ld.so.conf


sed "s@/usr/X11R6@<em class="replaceable"><code>$XORG_PREFIX</em>@g" -i /etc/man_db.conf


ln -sfv $XORG_PREFIX/share/X11 /usr/share/X11


ln -sfv $XORG_PREFIX /usr/X11R6


install -v -dm755 $XORG_PREFIX &&
install -v -dm755 $XORG_PREFIX/lib &&
ln -sfv lib $XORG_PREFIX/lib64


cd $SOURCE_DIR

echo "xorg7=>`date`" | sudo tee -a $INSTALLED_LIST

