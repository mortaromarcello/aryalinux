#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libass is a portable subtitlebr3ak renderer for the ASS/SSA (Advanced Substation Alpha/Substationbr3ak Alpha) subtitle format that allows for more advanced subtitles thanbr3ak the conventional SRT and similar formats.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:freetype2
#REQ:fribidi
#REC:fontconfig
#OPT:harfbuzz


#VER:libass:0.13.4


NAME="libass"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libass/libass-0.13.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libass/libass-0.13.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libass/libass-0.13.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libass/libass-0.13.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libass/libass-0.13.4.tar.xz || wget -nc https://github.com/libass/libass/releases/download/0.13.4/libass-0.13.4.tar.xz


URL=https://github.com/libass/libass/releases/download/0.13.4/libass-0.13.4.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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
