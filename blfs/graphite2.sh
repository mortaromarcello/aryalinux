#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Graphite2 is a rendering enginebr3ak for graphite fonts. These are TrueType fonts with additional tablesbr3ak containing smart rendering information and were originallybr3ak developed to support complex non-Roman writing systems. They maybr3ak contain rules for e.g. ligatures, glyph substitution, kerning,br3ak justification - this can make them useful even on text written inbr3ak Roman writing systems such as English. Note that firefox by default provides an internal copybr3ak of the graphite engine and cannot use a system version (although itbr3ak can now be patched to use it), but it too should benefit from thebr3ak availability of graphite fonts.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:cmake
#OPT:freetype2
#OPT:python2
#OPT:harfbuzz


#VER:graphite2:1.3.8


NAME="graphite2"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/graphite2/graphite2-1.3.8.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/graphite2/graphite2-1.3.8.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/graphite2/graphite2-1.3.8.tgz || wget -nc https://github.com/silnrsi/graphite/releases/download/1.3.8/graphite2-1.3.8.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/graphite2/graphite2-1.3.8.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/graphite2/graphite2-1.3.8.tgz


URL=https://github.com/silnrsi/graphite/releases/download/1.3.8/graphite2-1.3.8.tgz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '/cmptest/d' tests/CMakeLists.txt


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      .. &&
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