#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="%DESCRIPTION%"
SECTION="general"
VERSION=1.10.0
NAME="python-modules#pycairo"

#REQ:cairo
#REQ:python3


cd $SOURCE_DIR

URL=http://cairographics.org/releases/pycairo-1.10.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://cairographics.org/releases/pycairo-1.10.0.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/downloads/pycairo/pycairo-1.10.0-waf_unpack-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/pycairo-1.10.0-waf_unpack-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/pycairo-1.10.0-waf_python_3_4-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/pycairo/pycairo-1.10.0-waf_python_3_4-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

patch -Np1 -i ../pycairo-1.10.0-waf_unpack-1.patch     &&
wafdir=$(./waf unpack) &&
pushd $wafdir          &&
patch -Np1 -i ../../pycairo-1.10.0-waf_python_3_4-1.patch &&
popd                   &&
unset wafdir           &&
PYTHON=/usr/bin/python3 ./waf configure --prefix=/usr  &&
./waf build


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
./waf install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
