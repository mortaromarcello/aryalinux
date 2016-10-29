#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The mdadm package containsbr3ak administration tools for software RAID.br3ak"
SECTION="postlfs"
VERSION=3.4
NAME="mdadm"



wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mdadm/mdadm-3.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mdadm/mdadm-3.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mdadm/mdadm-3.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mdadm/mdadm-3.4.tar.xz || wget -nc http://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-3.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mdadm/mdadm-3.4.tar.xz


URL=http://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-3.4.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

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



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
