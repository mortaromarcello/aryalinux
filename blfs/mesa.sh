#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Mesa is an OpenGL compatible 3Dbr3ak graphics library.br3ak
#SECTION:x

#REQ:x7lib
#REQ:libdrm
#REQ:python2
#REC:elfutils
#REC:x7driver
#REC:llvm
#OPT:libgcrypt
#OPT:nettle
#OPT:wayland
#OPT:plasma-all
#OPT:lxqt


#VER:mesa:12.0.3


NAME="mesa"

wget -nc ftp://ftp.freedesktop.org/pub/mesa/12.0.3/mesa-12.0.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mesa/mesa-12.0.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mesa/mesa-12.0.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mesa/mesa-12.0.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mesa/mesa-12.0.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mesa/mesa-12.0.3.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/downloads/mesa/mesa-12.0.3-add_xdemos-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/mesa-12.0.3-add_xdemos-1.patch


URL=ftp://ftp.freedesktop.org/pub/mesa/12.0.3/mesa-12.0.3.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../mesa-12.0.3-add_xdemos-1.patch

GLL_DRV="i915,r600,nouveau,radeonsi,svga,swrast"

sed -i "/pthread-stubs/d" configure.ac      &&
sed -i "/seems to be moved/s/^/: #/" bin/ltmain.sh &&

./autogen.sh CFLAGS='-O2' CXXFLAGS='-O2'    \
            --prefix=$XORG_PREFIX           \
            --sysconfdir=/etc               \
            --enable-texture-float          \
            --enable-osmesa                 \
            --enable-xa                     \
            --enable-glx-tls                \
            --with-egl-platforms="drm,x11"  \
            --with-gallium-drivers=$GLL_DRV &&

unset GLL_DRV &&

make

make -C xdemos DEMOS_PREFIX=$XORG_PREFIX


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C xdemos DEMOS_PREFIX=$XORG_PREFIX install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/mesa-12.0.3 &&
cp -rfv docs/* /usr/share/doc/mesa-12.0.3
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
