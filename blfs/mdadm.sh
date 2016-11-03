#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The mdadm package containsbr3ak administration tools for software RAID.br3ak"
SECTION="postlfs"
VERSION=3.4
NAME="mdadm"



cd $SOURCE_DIR

URL=http://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-3.4.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mdadm/mdadm-3.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mdadm/mdadm-3.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mdadm/mdadm-3.4.tar.xz || wget -nc http://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-3.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mdadm/mdadm-3.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mdadm/mdadm-3.4.tar.xz

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

sed -i 's/-Werror//' Makefile &&
make "-j`nproc`" || make


sed -i 's# if.* == "1"#& -a -e $targetdir/log#' test &&
make test


./test --keep-going --logdir=test-logs --save-logs



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
