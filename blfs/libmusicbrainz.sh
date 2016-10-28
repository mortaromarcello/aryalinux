#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libmusicbrainz packagebr3ak contains a library which allows you to access the data held on thebr3ak MusicBrainz server. This is useful for adding MusicBrainz lookupbr3ak capabilities to other applications.br3ak
#SECTION:multimedia

#OPT:python2


#VER:libmusicbrainz:2.1.5


NAME="libmusicbrainz"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc ftp://ftp.musicbrainz.org/pub/musicbrainz/historical/libmusicbrainz-2.1.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz || wget -nc http://ftp.musicbrainz.org/pub/musicbrainz/historical/libmusicbrainz-2.1.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libmusicbrainz/libmusicbrainz-2.1.5.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/libmusicbrainz-2.1.5-missing-includes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/libmusicbrainz/libmusicbrainz-2.1.5-missing-includes-1.patch


URL=http://ftp.musicbrainz.org/pub/musicbrainz/historical/libmusicbrainz-2.1.5.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../libmusicbrainz-2.1.5-missing-includes-1.patch &&

CXXFLAGS=-std=c++98 \
./configure --prefix=/usr --disable-static &&
make

(cd python && python setup.py build)


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 -D docs/mb_howto.txt \
    /usr/share/doc/libmusicbrainz-2.1.5/mb_howto.txt
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
(cd python && python setup.py install)
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
