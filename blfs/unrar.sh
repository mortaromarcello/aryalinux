#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The UnRar package contains abr3ak <code class="filename">RAR extraction utility used forbr3ak extracting files from <code class="filename">RAR archives.br3ak <code class="filename">RAR archives are usually created withbr3ak WinRAR, primarily in a Windowsbr3ak environment.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:unrarsrc:5.4.5


NAME="unrar"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.4.5.tar.gz || wget -nc http://www.rarlab.com/rar/unrarsrc-5.4.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.4.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.4.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/unrarsrc/unrarsrc-5.4.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.4.5.tar.gz


URL=http://www.rarlab.com/rar/unrarsrc-5.4.5.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

make -f makefile



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 unrar /usr/bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
