#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:babl


cd $SOURCE_DIR

wget -nc http://download.gimp.org/pub/gegl/0.2/gegl-0.2.0.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/gegl-0.2.0-ffmpeg2-1.patch


TARBALL=gegl-0.2.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../gegl-0.2.0-ffmpeg2-1.patch &&
./configure --prefix=/usr &&
LC_ALL=en_US make

cat > 1434987998765.sh << "ENDOFFILE"
make install &&
install -v -m644 docs/*.{css,html} /usr/share/gtk-doc/html/gegl &&
install -d -v -m755 /usr/share/gtk-doc/html/gegl/images &&
install -v -m644 docs/images/* /usr/share/gtk-doc/html/gegl/images
ENDOFFILE
chmod a+x 1434987998765.sh
sudo ./1434987998765.sh
sudo rm -rf 1434987998765.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gegl=>`date`" | sudo tee -a $INSTALLED_LIST