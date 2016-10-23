#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Itstool extracts messages from XMLbr3ak files and outputs PO template files, then merges translations frombr3ak MO files to create translated XML files. It determines what tobr3ak translate and how to chunk it into messages using the W3Cbr3ak Internationalization Tag Set (ITS).br3ak
#SECTION:pst

whoami > /tmp/currentuser

#REQ:docbook
#REQ:python2


#VER:itstool:2.0.2


NAME="itstool"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/itstool/itstool-2.0.2.tar.bz2 || wget -nc http://files.itstool.org/itstool/itstool-2.0.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/itstool/itstool-2.0.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/itstool/itstool-2.0.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/itstool/itstool-2.0.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/itstool/itstool-2.0.2.tar.bz2


URL=http://files.itstool.org/itstool/itstool-2.0.2.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
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
