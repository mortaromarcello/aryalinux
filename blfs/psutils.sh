#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak PSUtils is a set of utilities tobr3ak manipulate PostScript files.br3ak
#SECTION:pst

whoami > /tmp/currentuser



#VER:psutils-p:17


NAME="psutils"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://pkgs.fedoraproject.org/repo/pkgs/psutils/psutils-p17.tar.gz/b161522f3bd1507655326afa7db4a0ad/psutils-p17.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/psutils/psutils-p17.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/psutils/psutils-p17.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/psutils/psutils-p17.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/psutils/psutils-p17.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/psutils/psutils-p17.tar.gz


URL=http://pkgs.fedoraproject.org/repo/pkgs/psutils/psutils-p17.tar.gz/b161522f3bd1507655326afa7db4a0ad/psutils-p17.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed 's@/usr/local@/usr@g' Makefile.unix > Makefile &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


lp -o number-up=2 <em class="replaceable"><code><filename></em>




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
