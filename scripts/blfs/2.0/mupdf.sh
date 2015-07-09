#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:x7lib
#DEP:libjpeg
#DEP:openjpeg2
#DEP:curl
#DEP:installing


cd $SOURCE_DIR

wget -nc http://www.mupdf.com/downloads/mupdf-1.6-source.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/mupdf-1.6-openjpeg21-1.patch


TARBALL=mupdf-1.6-source.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

rm -rf thirdparty/curl &&
rm -rf thirdparty/freetype &&
rm -rf thirdparty/jpeg &&
rm -rf thirdparty/openjpeg &&
rm -rf thirdparty/zlib &&
patch -Np1 -i ../mupdf-1.6-openjpeg21-1.patch &&
make build=release

cat > 1434987998843.sh << "ENDOFFILE"
install -v -m 755 build/release/mupdf-x11-curl /usr/bin/mupdf &&
install -v -m 644 docs/man/mupdf.1 /usr/share/man/man1/
ENDOFFILE
chmod a+x 1434987998843.sh
sudo ./1434987998843.sh
sudo rm -rf 1434987998843.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "mupdf=>`date`" | sudo tee -a $INSTALLED_LIST