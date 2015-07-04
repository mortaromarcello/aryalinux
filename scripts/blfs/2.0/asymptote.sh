#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gs
#DEP:texlive
#DEP:freeglut


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/sourceforge/asymptote/asymptote-2.32.src.tgz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/asymptote-2.32-ghostscript_fix-1.patch


TARBALL=asymptote-2.32.src.tgz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&
patch -Np1 -i ../asymptote-2.32-ghostscript_fix-1.patch &&

./configure --prefix=/opt/texlive/2014              \
            --bindir=/opt/texlive/2014/bin/$TEXARCH \
            --datarootdir=/opt/texlive/2014         \
            --libdir=/opt/texlive/2014/texmf-dist   \
            --mandir=/opt/texlive/2014/texmf-dist/doc/man &&
make

cat > 1434987998828.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998828.sh
sudo ./1434987998828.sh
sudo rm -rf 1434987998828.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "asymptote=>`date`" | sudo tee -a $INSTALLED_LIST