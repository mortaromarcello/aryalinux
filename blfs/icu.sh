#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The International Components forbr3ak Unicode (ICU) package is a mature, widely used set of C/C++br3ak libraries providing Unicode and Globalization support for softwarebr3ak applications. ICU is widelybr3ak portable and gives applications the same results on all platforms.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:llvm
#OPT:doxygen


#VER:icu4c-src:57_1


NAME="icu"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icu/icu4c-57_1-src.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icu/icu4c-57_1-src.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icu/icu4c-57_1-src.tgz || wget -nc http://download.icu-project.org/files/icu4c/57.1/icu4c-57_1-src.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icu/icu4c-57_1-src.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icu/icu4c-57_1-src.tgz


URL=http://download.icu-project.org/files/icu4c/57.1/icu4c-57_1-src.tgz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

cd source &&
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
