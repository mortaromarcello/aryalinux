#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The YAML package contains a Cbr3ak library for parsing and emitting YAML (YAML Ain't Markup Language).br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:doxygen


#VER:yaml:0.1.6


NAME="yaml"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/yaml/yaml-0.1.6.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/yaml/yaml-0.1.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/yaml/yaml-0.1.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/yaml/yaml-0.1.6.tar.gz || wget -nc http://pyyaml.org/download/libyaml/yaml-0.1.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/yaml/yaml-0.1.6.tar.gz


URL=http://pyyaml.org/download/libyaml/yaml-0.1.6.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
