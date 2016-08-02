#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xindy:2.5.1

#REQ:clisp
#REQ:texlive


cd $SOURCE_DIR

URL=http://tug.ctan.org/support/xindy/base/xindy-2.5.1.tar.gz

wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/xindy-2.5.1-upstream_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/xindy/xindy-2.5.1-upstream_fixes-1.patch
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xindy/xindy-2.5.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xindy/xindy-2.5.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xindy/xindy-2.5.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xindy/xindy-2.5.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xindy/xindy-2.5.1.tar.gz || wget -nc http://tug.ctan.org/support/xindy/base/xindy-2.5.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&
sed -i "s/ grep -v '^;'/ awk NF/" make-rules/inputenc/Makefile.in &&
patch -Np1 -i ../xindy-2.5.1-upstream_fixes-1.patch &&
./configure --prefix=/opt/texlive/2016              \
            --bindir=/opt/texlive/2016/bin/$TEXARCH \
            --datarootdir=/opt/texlive/2016         \
            --includedir=/usr/include               \
            --libdir=/opt/texlive/2016/texmf-dist   \
            --mandir=/opt/texlive/2016/texmf-dist/doc/man &&
make LC_ALL=POSIX



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xindy=>`date`" | sudo tee -a $INSTALLED_LIST

