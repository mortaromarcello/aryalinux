#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






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

install -v -m755 -d $XORG_PREFIX &&
install -v -m755 -d $XORG_PREFIX/lib &&
ln -s lib $XORG_PREFIX/lib64


 
cd $SOURCE_DIR
 
echo "xorg7=>`date`" | sudo tee -a $INSTALLED_LIST