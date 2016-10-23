#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The tree application, as the namebr3ak suggests, is useful to display, in a terminal, directory contents,br3ak including directories, files, links.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:tree:1.7.0


NAME="tree"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tree/tree-1.7.0.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tree/tree-1.7.0.tgz || wget -nc ftp://mama.indstate.edu/linux/tree/tree-1.7.0.tgz || wget -nc http://mama.indstate.edu/users/ice/tree/src/tree-1.7.0.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tree/tree-1.7.0.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tree/tree-1.7.0.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tree/tree-1.7.0.tgz


URL=http://mama.indstate.edu/users/ice/tree/src/tree-1.7.0.tgz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make MANDIR=/usr/share/man/man1 install &&
chmod -v 644 /usr/share/man/man1/tree.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST