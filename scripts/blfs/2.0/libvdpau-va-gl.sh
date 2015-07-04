#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:ffmpeg
#DEP:glu
#DEP:libva
#DEP:libvdpau


cd $SOURCE_DIR

wget -nc https://github.com/i-rinat/libvdpau-va-gl/releases/download/v0.3.4/libvdpau-va-gl-0.3.4.tar.gz


TARBALL=libvdpau-va-gl-0.3.4.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release &&
make

cat > 1434987998836.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998836.sh
sudo ./1434987998836.sh
sudo rm -rf 1434987998836.sh

cat > 1434987998836.sh << "ENDOFFILE"
cat > /etc/profile.d/libvdpau-va-gl.sh << "EOF"
# Begin /etc/profile.d/libvdpau-va-gl.sh

export VDPAU_DRIVER=va_gl

# End /etc/profile.d/libvdpau-va-gl.sh
EOF
ENDOFFILE
chmod a+x 1434987998836.sh
sudo ./1434987998836.sh
sudo rm -rf 1434987998836.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libvdpau-va-gl=>`date`" | sudo tee -a $INSTALLED_LIST