#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The AudioFile package contains thebr3ak audio file libraries and two sound file support programs useful tobr3ak support basic sound file formats.br3ak
#SECTION:multimedia

#REQ:alsa-lib
#REC:flac
#OPT:asciidoc
#OPT:valgrind


#VER:audiofile:0.3.6


NAME="audiofile"

wget -nc http://ftp.gnome.org/pub/gnome/sources/audiofile/0.3/audiofile-0.3.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/audiofile/audiofile-0.3.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/audiofile/audiofile-0.3.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/audiofile/audiofile-0.3.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/audiofile/audiofile-0.3.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/audiofile/audiofile-0.3.6.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/audiofile/0.3/audiofile-0.3.6.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/audiofile/0.3/audiofile-0.3.6.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

CXXFLAGS=-std=c++98 \
./configure --prefix=/usr --disable-static &&

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
