#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak MC (Midnight Commander) is abr3ak text-mode full-screen file manager and visual shell. It provides abr3ak clear, user-friendly, and somewhat protected interface to a Unixbr3ak system while making many frequent file operations more efficientbr3ak and preserving the full power of the command prompt.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:glib2
#REQ:pcre
#REC:slang
#OPT:doxygen
#OPT:gpm
#OPT:samba
#OPT:unzip
#OPT:zip
#OPT:xorg-server


#VER:mc:4.8.18


NAME="mc"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mc/mc-4.8.18.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mc/mc-4.8.18.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mc/mc-4.8.18.tar.xz || wget -nc http://ftp.midnight-commander.org/mc-4.8.18.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/midnightcommander/mc-4.8.18.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mc/mc-4.8.18.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mc/mc-4.8.18.tar.xz


URL=http://ftp.midnight-commander.org/mc-4.8.18.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --enable-charset &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
cp -v doc/keybind-migration.txt /usr/share/mc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
