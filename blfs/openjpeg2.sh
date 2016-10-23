#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak OpenJPEG is an open-sourcebr3ak implementation of the JPEG-2000 standard. OpenJPEG fully respectsbr3ak the JPEG-2000 specifications and can compress/decompress losslessbr3ak 16-bit images.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:cmake
#OPT:lcms2
#OPT:libpng
#OPT:libtiff
#OPT:doxygen


#VER:v:2.1.2


NAME="openjpeg2"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc https://github.com/uclouvain/openjpeg/archive/v2.1.2.tar.gz


URL=https://github.com/uclouvain/openjpeg/archive/v2.1.2.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

wget -c https://github.com/uclouvain/openjpeg/archive/v2.1.2.tar.gz \
     -O openjpeg-2.1.2.tar.gz


mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
pushd ../doc &&
for man in man/man?/* ; do
    install -v -D -m 644 $man /usr/share/$man
done         &&
popd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST