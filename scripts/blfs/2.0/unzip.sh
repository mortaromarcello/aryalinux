#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/infozip/unzip60.tar.gz


TARBALL=unzip60.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

case `uname -m` in
  i?86)
    sed -i -e 's/DASM_CRC"/DASM_CRC -DNO_LCHMOD"/' unix/Makefile
    make -f unix/Makefile linux
    ;;
  *)
    sed -i -e 's/CFLAGS="-O -Wall/& -DNO_LCHMOD/' unix/Makefile
    make -f unix/Makefile linux_noasm
    ;;
esac

cat > 1434987998773.sh << "ENDOFFILE"
make prefix=/usr MANDIR=/usr/share/man/man1 install
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "unzip=>`date`" | sudo tee -a $INSTALLED_LIST