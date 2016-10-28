#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libcanberra is an implementationbr3ak of the XDG Sound Theme and Name Specifications, for generatingbr3ak event sounds on free desktops, such as GNOME.br3ak
#SECTION:multimedia

#REQ:libvorbis
#REC:alsa-lib
#REC:gstreamer10
#REC:gtk3
#OPT:gtk2
#OPT:gtk-doc
#OPT:pulseaudio


#VER:libcanberra:0.30


NAME="libcanberra"

wget -nc http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcanberra/libcanberra-0.30.tar.xz


URL=http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-oss &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/libcanberra-0.30 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
