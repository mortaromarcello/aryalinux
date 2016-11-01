#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Subversion is a version controlbr3ak system that is designed to be a compelling replacement forbr3ak CVS in the open source community.br3ak It extends and enhances CVS'br3ak feature set, while maintaining a similar interface for thosebr3ak already familiar with CVS. Thesebr3ak instructions install the client and server software used tobr3ak manipulate a Subversionbr3ak repository. Creation of a repository is covered at <a class=\"xref\" br3ak href=\"svnserver.html\" title=\"Running a Subversion Server\">Running abr3ak Subversion Server</a>.br3ak"
SECTION="general"
VERSION=1.9.4
NAME="subversion"

#REQ:apr-util
#REQ:sqlite
#REC:serf
#OPT:apache
#OPT:cyrus-sasl
#OPT:dbus
#OPT:python2
#OPT:ruby
#OPT:swig
#OPT:openjdk
#OPT:junit


cd $SOURCE_DIR

URL=http://www.apache.org/dist/subversion/subversion-1.9.4.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://www.apache.org/dist/subversion/subversion-1.9.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/subversion/subversion-1.9.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/subversion/subversion-1.9.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/subversion/subversion-1.9.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/subversion/subversion-1.9.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/subversion/subversion-1.9.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" build/ltmain.sh &&
./configure --prefix=/usr    \
            --disable-static \
            --with-apache-libexecdir &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/subversion-1.9.4 &&
cp      -v -R       doc/* \
                    /usr/share/doc/subversion-1.9.4

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
