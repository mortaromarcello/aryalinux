#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libvdpau-va-gl:0.3.6

#REQ:cmake
#REQ:ffmpeg
#REQ:glu
#REQ:libva
#REQ:libvdpau


cd $SOURCE_DIR

URL=https://github.com/i-rinat/libvdpau-va-gl/releases/download/v0.3.6/libvdpau-va-gl-0.3.6.tar.gz

wget -nc https://github.com/i-rinat/libvdpau-va-gl/releases/download/v0.3.6/libvdpau-va-gl-0.3.6.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/libvdpau-va-gl.sh << "EOF"
# Begin /etc/profile.d/libvdpau-va-gl.sh
export VDPAU_DRIVER=va_gl
# End /etc/profile.d/libvdpau-va-gl.sh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libvdpau-va-gl=>`date`" | sudo tee -a $INSTALLED_LIST

