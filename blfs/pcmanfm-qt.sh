#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The pcmanfm-qt is a file managerbr3ak and desktop icon manager (Qt portbr3ak of pcmanfm and libfm).br3ak
#SECTION:lxqt

whoami > /tmp/currentuser

#REQ:liblxqt
#REQ:libfm-qt
#REQ:lxmenu-data
#REC:oxygen-icons5
#OPT:git
#OPT:lxqt-l10n


#VER:pcmanfm-qt:0.11.1


NAME="pcmanfm-qt"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://downloads.lxqt.org/pcmanfm-qt/0.11.1/pcmanfm-qt-0.11.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcmanfm/pcmanfm-qt-0.11.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcmanfm/pcmanfm-qt-0.11.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pcmanfm/pcmanfm-qt-0.11.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pcmanfm/pcmanfm-qt-0.11.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pcmanfm/pcmanfm-qt-0.11.1.tar.xz


URL=http://downloads.lxqt.org/pcmanfm-qt/0.11.1/pcmanfm-qt-0.11.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DPULL_TRANSLATIONS=no              \
      -DCMAKE_INSTALL_LIBDIR=lib          \
      ..       &&
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
