#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Phonon is the multimedia API forbr3ak KDE. It replaces the old aRtsbr3ak package. Phonon needs either the GStreamer or VLC backend.br3ak
#SECTION:kde

whoami > /tmp/currentuser

#REQ:cmake
#REQ:extra-cmake-modules
#REQ:glib2
#REQ:qt5
#OPT:pulseaudio


#VER:phonon:4.9.0


NAME="phonon"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://download.kde.org/stable/phonon/4.9.0/phonon-4.9.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/phonon/phonon-4.9.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/phonon/phonon-4.9.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/phonon/phonon-4.9.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/phonon/phonon-4.9.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/phonon/phonon-4.9.0.tar.xz


URL=http://download.kde.org/stable/phonon/4.9.0/phonon-4.9.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr    \
      -DCMAKE_BUILD_TYPE=Release     \
      -DCMAKE_INSTALL_LIBDIR=lib     \
      -DPHONON_BUILD_PHONON4QT5=ON   \
      -Wno-dev .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST