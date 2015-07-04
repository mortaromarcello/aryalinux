#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:fltk
#DEP:gnutls
#DEP:libgcrypt
#DEP:libjpeg
#DEP:pixman
#DEP:x7app
#DEP:imagemagick
#DEP:linux-pam


cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/sources/BLFS/conglomeration/tigervnc/tigervnc-1.4.2.tar.gz
wget -nc http://xorg.freedesktop.org/archive/individual/xserver/xorg-server-1.16.2.901.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/tigervnc-1.4.2-gethomedir-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/tigervnc-1.4.2-getmaster-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/tigervnc-1.4.2-xorg116-1.patch


TARBALL=tigervnc-1.4.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

tar -xf ../xorg-server-1.16.2.901.tar.bz2 -C unix/xserver --strip-components=1 &&

patch -Np1 -i ../tigervnc-1.4.2-gethomedir-1.patch &&
patch -Np1 -i ../tigervnc-1.4.2-getmaster-1.patch  &&

cmake -DCMAKE_INSTALL_PREFIX=/usr &&
make &&

pushd unix/xserver                                      &&
  patch -Np1 -i ../../../tigervnc-1.4.2-xorg116-1.patch &&
  autoreconf -fi                                        &&

  ./configure $XORG_CONFIG \
      --disable-xwayland    --enable-dri3        --disable-dmx         \
      --disable-static      --disable-xinerama   --disable-dri         \
      --disable-xorg        --disable-xnest      --disable-xvfb        \
      --disable-xwin        --disable-xephyr     --disable-kdrive      \
      --disable-devel-docs  --disable-config-hal --disable-config-udev \
      --disable-unit-tests  --disable-selective-werror                 \
      --without-dtrace      --enable-dri2        --enable-glx          \
      --enable-glx-tls      --with-pic  &&
  make    &&
popd

cat > 1434987998830.sh << "ENDOFFILE"
make install &&

cd unix/xserver/hw/vnc &&
make install           &&
sed -i 's/iconic/nowin/' /usr/bin/vncserver &&
[ -e /usr/bin/Xvnc ] || ln -svf $XORG_PREFIX/bin/Xvnc /usr/bin/Xvnc
ENDOFFILE
chmod a+x 1434987998830.sh
sudo ./1434987998830.sh
sudo rm -rf 1434987998830.sh

cat > 1434987998830.sh << "ENDOFFILE"
cat > /usr/share/applications/vncviewer.desktop << "EOF"
[Desktop Entry]
Type=Application
Name=TigerVNC Viewer
Comment=VNC client
Exec=/usr/bin/vncviewer
Icon=tigervnc
Terminal=false
StartupNotify=false
Categories=Network;RemoteAccess;
EOF
ENDOFFILE
chmod a+x 1434987998830.sh
sudo ./1434987998830.sh
sudo rm -rf 1434987998830.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "tigervnc=>`date`" | sudo tee -a $INSTALLED_LIST