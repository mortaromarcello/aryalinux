#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The cifs-utils provides a meansbr3ak for mounting SMB/CIFS shares on a Linux system.br3ak"
SECTION="basicnet"
VERSION=6.6
NAME="cifsutils"

#OPT:keyutils
#OPT:linux-pam
#OPT:mitkrb
#OPT:talloc
#OPT:samba
#OPT:libcap


cd $SOURCE_DIR

URL=https://ftp.samba.org/pub/linux-cifs/cifs-utils/cifs-utils-6.6.tar.bz2

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cifs-utils/cifs-utils-6.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cifs-utils/cifs-utils-6.6.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cifs-utils/cifs-utils-6.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cifs-utils/cifs-utils-6.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cifs-utils/cifs-utils-6.6.tar.bz2 || wget -nc https://ftp.samba.org/pub/linux-cifs/cifs-utils/cifs-utils-6.6.tar.bz2

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

./configure --prefix=/usr \
            --disable-pam &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
