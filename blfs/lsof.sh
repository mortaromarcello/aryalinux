#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The lsof package is useful to LiStbr3ak Open Files for a given running application or process.br3ak"
SECTION="general"
VERSION=4.89
NAME="lsof"

#REQ:libtirpc


cd $SOURCE_DIR

URL=https://www.mirrorservice.org/sites/lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.89.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lsof/lsof_4.89.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lsof/lsof_4.89.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lsof/lsof_4.89.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lsof/lsof_4.89.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lsof/lsof_4.89.tar.bz2 || wget -nc https://www.mirrorservice.org/sites/lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_4.89.tar.bz2

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

tar -xf lsof_4.89_src.tar  &&
cd lsof_4.89_src           &&
./Configure -n linux       &&
make CFGL="-L./lib -ltirpc"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m0755 -o root -g root lsof /usr/bin &&
install -v lsof.8 /usr/share/man/man8

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
