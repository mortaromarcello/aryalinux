#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:git:2.7.1
#VER:git-manpages:2.7.1
#VER:git-htmldocs:2.7.1

#REC:curl
#REC:openssl
#REC:python2
#OPT:pcre
#OPT:subversion
#OPT:tk
#OPT:valgrind


cd $SOURCE_DIR

URL=https://www.kernel.org/pub/software/scm/git/git-2.7.1.tar.xz

wget -nc https://www.kernel.org/pub/software/scm/git/git-manpages-2.7.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-manpages-2.7.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/git/git-manpages-2.7.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-manpages-2.7.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/git/git-manpages-2.7.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/git/git-manpages-2.7.1.tar.xz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/git/git-htmldocs-2.7.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-htmldocs-2.7.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/git/git-htmldocs-2.7.1.tar.xz || wget -nc https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.7.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-htmldocs-2.7.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/git/git-htmldocs-2.7.1.tar.xz
wget -nc https://www.kernel.org/pub/software/scm/git/git-2.7.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/git/git-2.7.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/git/git-2.7.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/git/git-2.7.1.tar.xz || wget -nc ftp://ftp.kernel.org/pub/software/scm/git/git-2.7.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-2.7.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-2.7.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --with-gitconfig=/etc/gitconfig &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tar -xf ../git-manpages-2.7.1.tar.xz \
    -C /usr/share/man --no-same-owner --no-overwrite-dir

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -vp   /usr/share/doc/git-2.7.1 &&
tar   -xf   ../git-htmldocs-2.7.1.tar.xz \
      -C    /usr/share/doc/git-2.7.1 --no-same-owner --no-overwrite-dir &&
find        /usr/share/doc/git-2.7.1 -type d -exec chmod 755 {} \; &&
find        /usr/share/doc/git-2.7.1 -type f -exec chmod 644 {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "git=>`date`" | sudo tee -a $INSTALLED_LIST

