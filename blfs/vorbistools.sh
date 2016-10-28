#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Vorbis Tools package containsbr3ak command-line tools useful for encoding, playing or editing filesbr3ak using the Ogg CODEC.br3ak
#SECTION:multimedia

#REQ:libvorbis
#OPT:libao
#OPT:curl
#OPT:flac
#OPT:speex


#VER:vorbis-tools:1.4.0


NAME="vorbistools"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vorbis-tools/vorbis-tools-1.4.0.tar.gz || wget -nc http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vorbis-tools/vorbis-tools-1.4.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vorbis-tools/vorbis-tools-1.4.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vorbis-tools/vorbis-tools-1.4.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vorbis-tools/vorbis-tools-1.4.0.tar.gz


URL=http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr \
            --enable-vcut \
            --without-curl &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
