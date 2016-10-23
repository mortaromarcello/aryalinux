#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Ed is a line-oriented text editor.br3ak It is used to create, display, modify and otherwise manipulate textbr3ak files, both interactively and via shell scripts. Ed isn't somethingbr3ak which many people use. It's described here because it can be usedbr3ak by the patch program if you encounter an ed-based patch file. Thisbr3ak happens rarely because diff-based patches are preferred these days.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#REQ:libarchive




NAME="ed"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi



URL=
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --bindir=/bin &&
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
