#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The icon-naming-utils packagebr3ak contains a Perl script used forbr3ak maintaining backwards compatibility with current desktop iconbr3ak themes, while migrating to the names specified in the <a class="ulink" href="http://standards.freedesktop.org/icon-naming-spec/latest/">Iconbr3ak Naming Specification</a>.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:perl-modules#perl-xml-simple


#VER:icon-naming-utils:0.8.90


NAME="icon-naming-utils"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icon-naming-utils/icon-naming-utils-0.8.90.tar.bz2 || wget -nc http://tango.freedesktop.org/releases/icon-naming-utils-0.8.90.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icon-naming-utils/icon-naming-utils-0.8.90.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icon-naming-utils/icon-naming-utils-0.8.90.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icon-naming-utils/icon-naming-utils-0.8.90.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icon-naming-utils/icon-naming-utils-0.8.90.tar.bz2


URL=http://tango.freedesktop.org/releases/icon-naming-utils-0.8.90.tar.bz2
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