#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:tigervnc:1.6.0
#VER:xorg-server:1.18.0

#REQ:cmake
#REQ:fltk
#REQ:gnutls
#REQ:libgcrypt
#REQ:libjpeg
#REQ:pixman
#REQ:x7app
#REC:imagemagick
#REC:linux-pam


cd $SOURCE_DIR

URL=http://anduin.linuxfromscratch.org/BLFS/tigervnc/tigervnc-1.6.0.tar.gz

wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/tigervnc-1.6.0-gethomedir-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/tigervnc/tigervnc-1.6.0-gethomedir-1.patch
wget -nc http://anduin.linuxfromscratch.org/BLFS/tigervnc/tigervnc-1.6.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tigervnc/tigervnc-1.6.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tigervnc/tigervnc-1.6.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tigervnc/tigervnc-1.6.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tigervnc/tigervnc-1.6.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tigervnc/tigervnc-1.6.0.tar.gz
wget -nc http://ftp.x.org/pub/individual/xserver/xorg-server-1.18.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/Xorg/xorg-server-1.18.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xorg-server-1.18.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xorg-server-1.18.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/Xorg/xorg-server-1.18.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/Xorg/xorg-server-1.18.0.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/tigervnc-1.6.0-xorg118-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/tigervnc/tigervnc-1.6.0-xorg118-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

patch -Np1 -i ../tigervnc-1.6.0-xorg118-1.patch    &&
patch -Np1 -i ../tigervnc-1.6.0-gethomedir-1.patch &&
mkdir -vp build &&
cd        build &&
# Build viewer
cmake -G "Unix Makefiles"         \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -Wno-dev .. &&
make &&
# Build server
cp -vR ../unix/xserver unix/ &&
tar -xf ../xorg-server-1.18.0.tar.bz2 -C unix/xserver --strip-components=1         &&
pushd unix/xserver &&
  patch -Np1 -i ../../../unix/xserver117.patch &&
  autoreconf -fi   &&
  ./configure $XORG_CONFIG \
      --disable-xwayland    --disable-dri        --disable-dmx         \
      --disable-xorg        --disable-xnest      --disable-xvfb        \
      --disable-xwin        --disable-xephyr     --disable-kdrive      \
      --disable-devel-docs  --disable-config-hal --disable-config-udev \
      --disable-unit-tests  --disable-selective-werror                 \
      --disable-static      --enable-dri3                              \
      --without-dtrace      --enable-dri2        --enable-glx          \
      --with-pic &&
  make TIGERVNC_SRCDIR=`pwd`/../../../ &&
popd



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
#Install viewer
make install &&
#Install server
pushd unix/xserver/hw/vnc &&
  make install &&
popd &&
[ -e /usr/bin/Xvnc ] || ln -svf $XORG_PREFIX/bin/Xvnc /usr/bin/Xvnc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
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
install -vm644 ../media/icons/tigervnc_24.png /usr/share/pixmaps &&
ln -sfv tigervnc_24.png /usr/share/pixmaps/tigervnc.png

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "tigervnc=>`date`" | sudo tee -a $INSTALLED_LIST

