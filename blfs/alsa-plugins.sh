#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The ALSA Plugins package containsbr3ak plugins for various audio libraries and sound servers.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:alsa-lib
#OPT:ffmpeg
#OPT:libsamplerate
#OPT:pulseaudio
#OPT:speex


#VER:alsa-plugins:1.1.1


NAME="alsa-plugins"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-plugins/alsa-plugins-1.1.1.tar.bz2 || wget -nc ftp://ftp.alsa-project.org/pub/plugins/alsa-plugins-1.1.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/alsa-plugins/alsa-plugins-1.1.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-plugins/alsa-plugins-1.1.1.tar.bz2 || wget -nc http://alsa.cybermirror.org/plugins/alsa-plugins-1.1.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/alsa-plugins/alsa-plugins-1.1.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/alsa-plugins/alsa-plugins-1.1.1.tar.bz2


URL=http://alsa.cybermirror.org/plugins/alsa-plugins-1.1.1.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure &&
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
