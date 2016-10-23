#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libdiscid package contains abr3ak library for creating MusicBrainz DiscIDs from audio CDs. It reads abr3ak CD's table of contents (TOC) and generates an identifier which canbr3ak be used to lookup the CD at MusicBrainz (<a class="ulink" href="http://musicbrainz.org">http://musicbrainz.org</a>). Additionally,br3ak it provides a submission URL for adding the DiscID to the database.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#OPT:doxygen


#VER:libdiscid:0.6.1


NAME="libdiscid"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdiscid/libdiscid-0.6.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdiscid/libdiscid-0.6.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdiscid/libdiscid-0.6.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdiscid/libdiscid-0.6.1.tar.gz || wget -nc ftp://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdiscid/libdiscid-0.6.1.tar.gz


URL=http://ftp.musicbrainz.org/pub/musicbrainz/libdiscid/libdiscid-0.6.1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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