#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak SCons is a tool for buildingbr3ak software (and other files) implemented in Python.br3ak
#SECTION:general

#REQ:python2
#OPT:docbook-xsl
#OPT:libxml2
#OPT:libxslt


#VER:scons:2.5.0


NAME="scons"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/scons/scons-2.5.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/scons/scons-2.5.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/scons/scons-2.5.0.tar.gz || wget -nc http://downloads.sourceforge.net/scons/scons-2.5.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/scons/scons-2.5.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/scons/scons-2.5.0.tar.gz


URL=http://downloads.sourceforge.net/scons/scons-2.5.0.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python setup.py install --prefix=/usr  \
                        --standard-lib \
                        --optimize=1   \
                        --install-data=/usr/share
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
