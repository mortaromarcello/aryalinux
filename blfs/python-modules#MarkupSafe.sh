#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="%DESCRIPTION%"
SECTION="general"
VERSION=0.23
NAME="python-modules#MarkupSafe"

#REQ:python-modules#setuptools


wget -nc https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz


URL=https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

python setup.py build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python setup.py install --optimize=1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


python3 setup.py build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
python3 setup.py install --optimize=1
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
