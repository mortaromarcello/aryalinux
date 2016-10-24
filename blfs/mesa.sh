#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#VER:mesa:12.0.1

#REQ:x7lib
#REQ:libdrm
#REQ:python2
#REC:elfutils
#REC:libva-wo-mesa
#REQ:libvdpau
#REC:llvm
#OPT:libgcrypt
#OPT:nettle
#OPT:wayland
#OPT:plasma-all


cd $SOURCE_DIR

URL=ftp://ftp.freedesktop.org/pub/mesa/12.0.1/mesa-12.0.1.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz || wget -nc ftp://ftp.freedesktop.org/pub/mesa/12.0.1/mesa-12.0.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mesa/mesa-12.0.1.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/downloads/mesa/mesa-12.0.1-add_xdemos-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/mesa-12.0.1-add_xdemos-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

patch -Np1 -i ../mesa-12.0.1-add_xdemos-1.patch

EGL_PLATFORMS="drm,x11"
DRI_DRIVERS="i915,i965,nouveau,r200,radeon,swrast"
GLL_DRV="nouveau,r300,r600,radeonsi,svga,swrast" &&
sed -i "/pthread-stubs/d" configure.ac      &&
#sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
export VDPAU_CFLAGS="-I@includedir@"
export VDPAU_LIBS="-L@libdir@ -lvdpau"
./autogen.sh CFLAGS='-O2' CXXFLAGS='-O2'		\
            --prefix=$XORG_PREFIX				\
            --sysconfdir=/etc					\
            --enable-texture-float				\
            --enable-gles1						\
            --enable-gles2						\
            --enable-osmesa						\
            --enable-xa               	    	\
			--enable-gallium-llvm				\
			--enable-llvm-shared-libs			\
			--enable-egl						\
			--enable-shared-glapi				\
            --enable-gbm        	            \
			--enable-nine						\
			--enable-glx						\
			--enable-dri						\
			--enable-dri3						\
            --enable-glx-tls					\
			--enable-vdpau						\
			--with-egl-platforms="$EGL_PLATFORMS" \
			--with-dri-drivers="$DRI_DRIVERS"	\
            --with-gallium-drivers=$GLL_DRV &&
unset GLL_DRV &&
make "-j`nproc`"


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
install -v -dm755 /usr/share/doc/mesa-12.0.1 &&
cp -rfv docs/* /usr/share/doc/mesa-12.0.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mesa=>`date`" | sudo tee -a $INSTALLED_LIST

