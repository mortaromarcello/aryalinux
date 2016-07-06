#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:mesa:11.1.1

#REQ:libdrm
#REQ:x7lib
#REC:elfutils
#REC:libva
#REC:libvdpau
#REC:llvm
#REC:wayland
#OPT:libgcrypt
#OPT:nettle


cd $SOURCE_DIR

URL=ftp://ftp.freedesktop.org/pub/mesa/11.1.1/mesa-11.1.1.tar.xz

wget -nc ftp://ftp.freedesktop.org/pub/mesa/11.1.1/mesa-11.1.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mesa/mesa-11.1.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mesa/mesa-11.1.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mesa/mesa-11.1.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mesa/mesa-11.1.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mesa/mesa-11.1.1.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/downloads/mesa/mesa-11.1.1-add_xdemos-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/mesa-11.1.1-add_xdemos-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../mesa-11.1.1-add_xdemos-1.patch


./configure CFLAGS="-O2" CXXFLAGS="-O2"  \
            --prefix=/usr                \
            --sysconfdir=/etc            \
            --enable-texture-float       \
            --enable-gles1               \
            --enable-gles2               \
            --enable-xa                  \
            --enable-glx-tls             \
            --enable-osmesa              \
            --with-egl-platforms="drm,x11,wayland" \
            --with-gallium-drivers="nouveau,r300,r600,radeonsi,svga,swrast" &&
make "-j`nproc`"


make -C xdemos DEMOS_PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C xdemos DEMOS_PREFIX=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/mesa-11.1.1 &&
cp -rfv docs/* /usr/share/doc/mesa-11.1.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mesa=>`date`" | sudo tee -a $INSTALLED_LIST

