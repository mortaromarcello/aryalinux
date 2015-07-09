#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/tcl/tcl8.6.3-src.tar.gz
wget -nc http://downloads.sourceforge.net/tcl/tcl8.6.3-html.tar.gz


TARBALL=tcl8.6.3-src.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

tar -xf ../tcl8.6.3-html.tar.gz --strip-components=1

export SRCDIR=`pwd` &&

cd unix &&

./configure --prefix=/usr           \
            --without-tzdata        \
            --mandir=/usr/share/man \
            $([ $(uname -m) = x86_64 ] && echo --enable-64bit) &&
make &&

sed -e "s#$SRCDIR/unix#/usr/lib#" \
    -e "s#$SRCDIR#/usr/include#"  \
    -i tclConfig.sh               &&

sed -e "s#$SRCDIR/unix/pkgs/tdbc1.0.2#/usr/lib/tdbc1.0.2#" \
    -e "s#$SRCDIR/pkgs/tdbc1.0.2/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/tdbc1.0.2/library#/usr/lib/tcl8.6#" \
    -e "s#$SRCDIR/pkgs/tdbc1.0.2#/usr/include#"            \
    -i pkgs/tdbc1.0.2/tdbcConfig.sh                        &&

sed -e "s#$SRCDIR/unix/pkgs/itcl4.0.2#/usr/lib/itcl4.0.2#" \
    -e "s#$SRCDIR/pkgs/itcl4.0.2/generic#/usr/include#"    \
    -e "s#$SRCDIR/pkgs/itcl4.0.2#/usr/include#"            \
    -i pkgs/itcl4.0.2/itclConfig.sh                        &&

unset SRCDIR

cat > 1434987998779.sh << "ENDOFFILE"
make install &&
make install-private-headers &&
ln -sfv tclsh8.6 /usr/bin/tclsh &&
chmod -v 755 /usr/lib/libtcl8.6.so
ENDOFFILE
chmod a+x 1434987998779.sh
sudo ./1434987998779.sh
sudo rm -rf 1434987998779.sh

cat > 1434987998779.sh << "ENDOFFILE"
mkdir -v -p /usr/share/doc/tcl-8.6.3 &&
cp -v -r  ../html/* /usr/share/doc/tcl-8.6.3
ENDOFFILE
chmod a+x 1434987998779.sh
sudo ./1434987998779.sh
sudo rm -rf 1434987998779.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "tcl=>`date`" | sudo tee -a $INSTALLED_LIST