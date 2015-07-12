#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libdrm
#DEP:python2
#DEP:x7lib
#DEP:elfutils
#DEP:libva-without-mesa
#DEP:libvdpau
#DEP:llvm
#DEP:wayland


cd $SOURCE_DIR

wget -nc ftp://ftp.freedesktop.org/pub/mesa/10.4.5/MesaLib-10.4.5.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/MesaLib-10.4.5-add_xdemos-1.patch


TARBALL=MesaLib-10.4.5.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../MesaLib-10.4.5-add_xdemos-1.patch

autoreconf -fi &&
./configure CFLAGS="-O2" CXXFLAGS="-O2"  \
            --prefix=/usr                \
            --sysconfdir=/etc            \
            --enable-texture-float       \
            --enable-gles1               \
            --enable-gles2               \
            --enable-xa                  \
            --enable-glx-tls             \
            --with-egl-platforms="drm,x11,wayland" \
            --with-gallium-drivers="nouveau,r300,r600,radeonsi,svga,swrast" &&
make

make -C xdemos DEMOS_PREFIX=/usr

cat > 1434987998790.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998790.sh
sudo ./1434987998790.sh
sudo rm -rf 1434987998790.sh

cat > 1434987998790.sh << "ENDOFFILE"
make -C xdemos DEMOS_PREFIX=/usr install
ENDOFFILE
chmod a+x 1434987998790.sh
sudo ./1434987998790.sh
sudo rm -rf 1434987998790.sh

cat > 1434987998790.sh << "ENDOFFILE"
install -v -dm755 /usr/share/doc/MesaLib-10.4.5 &&
cp -rfv docs/* /usr/share/doc/MesaLib-10.4.5
ENDOFFILE
chmod a+x 1434987998790.sh
sudo ./1434987998790.sh
sudo rm -rf 1434987998790.sh



cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "mesalib=>`date`" | sudo tee -a $INSTALLED_LIST
