#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak pavucontrol-qt is the Qt port ofbr3ak volume control pavucontrol of sound server PulseAudio. Its use isbr3ak not limited to LXQt.br3ak"
SECTION="lxqt"
VERSION=0.1.0
NAME="pavucontrol-qt"

#REQ:liblxqt
#REQ:pulseaudio


cd $SOURCE_DIR

URL=https://downloads.lxqt.org/pavucontrol-qt/0.1.0/pavucontrol-qt-0.1.0.tar.xz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pavucontrol-qt/pavucontrol-qt-0.1.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pavucontrol-qt/pavucontrol-qt-0.1.0.tar.xz || wget -nc https://downloads.lxqt.org/pavucontrol-qt/0.1.0/pavucontrol-qt-0.1.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pavucontrol-qt/pavucontrol-qt-0.1.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pavucontrol-qt/pavucontrol-qt-0.1.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pavucontrol-qt/pavucontrol-qt-0.1.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      ..       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
