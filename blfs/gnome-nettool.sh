#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GNOME Nettool package is abr3ak network information tool which provides GUI interface for some ofbr3ak the most common command line network tools.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:gtk3
#REQ:itstool
#REQ:libgtop
#OPT:bind-utils
#OPT:nmap
#OPT:net-tools
#OPT:traceroute
#OPT:whois


#VER:gnome-nettool:3.8.1


NAME="gnome-nettool"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-nettool/gnome-nettool-3.8.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-nettool/gnome-nettool-3.8.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-nettool/gnome-nettool-3.8.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-nettool/3.8/gnome-nettool-3.8.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-nettool/3.8/gnome-nettool-3.8.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-nettool/gnome-nettool-3.8.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-nettool/gnome-nettool-3.8.1.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-nettool/3.8/gnome-nettool-3.8.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
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