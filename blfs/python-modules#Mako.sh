#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:%DESCRIPTION%
#SECTION:general

#REQ:python-modules#Beaker
#REQ:python-modules#MarkupSafe


#VER:Mako:1.0.4


NAME="python-modules#Mako"

wget -nc https://pypi.python.org/packages/source/M/Mako/Mako-1.0.4.tar.gz


URL=https://pypi.python.org/packages/source/M/Mako/Mako-1.0.4.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python setup.py install --optimize=1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i "s:mako-render:&3:g" setup.py &&
python3 setup.py install --optimize=1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
