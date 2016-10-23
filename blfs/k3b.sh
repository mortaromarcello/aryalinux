#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The K3b package contains abr3ak KF5-based graphical interface to the Cdrtools and dvd+rw-tools CD/DVD manipulation tools. Itbr3ak also combines the capabilities of many other multimedia packagesbr3ak into one central interface to provide a simple-to-operatebr3ak application that can be used to handle many of your CD/DVDbr3ak recording and formatting requirements. It is used for creatingbr3ak audio, data, video and mixed-mode CDs as well as copying, rippingbr3ak and burning CDs and DVDs.br3ak
#SECTION:kde

whoami > /tmp/currentuser

#REQ:libkcddb
#REQ:libsamplerate
#REQ:shared-mime-info
#REQ:kframeworks5
#REC:ffmpeg
#REC:libdvdread
#REC:taglib
#OPT:flac
#OPT:lame
#OPT:libmad
#OPT:libsndfile
#OPT:libvorbis
#OPT:libmusicbrainz


#VER:k3b-2016-09:11


NAME="k3b"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/k3b/k3b-2016-09-11.tar.xz || wget -nc http://anduin.linuxfromscratch.org/BLFS/k3b/k3b-2016-09-11.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/k3b/k3b-2016-09-11.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/k3b/k3b-2016-09-11.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/k3b/k3b-2016-09-11.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/k3b/k3b-2016-09-11.tar.xz


URL=http://anduin.linuxfromscratch.org/BLFS/k3b/k3b-2016-09-11.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -Wno-dev ..                        &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
