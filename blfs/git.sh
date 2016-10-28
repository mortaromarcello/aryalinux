#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Git is a free and open source,br3ak distributed version control system designed to handle everythingbr3ak from small to very large projects with speed and efficiency. Everybr3ak Git clone is a full-fledgedbr3ak repository with complete history and full revision trackingbr3ak capabilities, not dependent on network access or a central server.br3ak Branching and merging are fast and easy to do. Git is used for version control of files, muchbr3ak like tools such as <a class="xref" href="mercurial.html" title="Mercurial-3.9.2">Mercurial-3.9.2</a>, Bazaar, <a class="xref" href="subversion.html" br3ak title="Subversion-1.9.4">Subversion-1.9.4</a>, <a class="ulink" br3ak href="http://www.nongnu.org/cvs/">CVS</a>, Perforce, and Teambr3ak Foundation Server.br3ak
#SECTION:general

#REC:curl
#REC:openssl
#REC:python2
#OPT:pcre
#OPT:subversion
#OPT:tk
#OPT:valgrind


#VER:git:2.10.1
#VER:git-manpages:2.10.1
#VER:git-htmldocs:2.10.1


NAME="git"

wget -nc https://www.kernel.org/pub/software/scm/git/git-2.10.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-2.10.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-2.10.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/git/git-2.10.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/git/git-2.10.1.tar.xz || wget -nc ftp://ftp.kernel.org/pub/software/scm/git/git-2.10.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/git/git-2.10.1.tar.xz
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/git/git-manpages-2.10.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/git/git-manpages-2.10.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/git/git-manpages-2.10.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-manpages-2.10.1.tar.xz || wget -nc https://www.kernel.org/pub/software/scm/git/git-manpages-2.10.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-manpages-2.10.1.tar.xz
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/git/git-htmldocs-2.10.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/git/git-htmldocs-2.10.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-htmldocs-2.10.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/git/git-htmldocs-2.10.1.tar.xz || wget -nc https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.10.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/git/git-htmldocs-2.10.1.tar.xz


URL=https://www.kernel.org/pub/software/scm/git/git-2.10.1.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --with-gitconfig=/etc/gitconfig &&
make

make html

make man


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://aryalinux.org/releases/2016.11/blfs-systemd-units-20160602.tar.bz2 -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-man
cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make htmldir=/usr/share/doc/git-2.10.1 install-html
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tar -xf ../git-manpages-2.10.1.tar.xz \
    -C /usr/share/man --no-same-owner --no-overwrite-dir
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -vp   /usr/share/doc/git-2.10.1 &&
tar   -xf   ../git-htmldocs-2.10.1.tar.xz \
      -C    /usr/share/doc/git-2.10.1 --no-same-owner --no-overwrite-dir &&

find        /usr/share/doc/git-2.10.1 -type d -exec chmod 755 {} \; &&
find        /usr/share/doc/git-2.10.1 -type f -exec chmod 644 {} \;
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -vp /usr/share/doc/git-2.10.1/man-pages/{html,text}         &&
mv        /usr/share/doc/git-2.10.1/{git*.txt,man-pages/text}     &&
mv        /usr/share/doc/git-2.10.1/{git*.,index.,man-pages/}html &&

mkdir -vp /usr/share/doc/git-2.10.1/technical/{html,text}         &&
mv        /usr/share/doc/git-2.10.1/technical/{*.txt,text}        &&
mv        /usr/share/doc/git-2.10.1/technical/{*.,}html           &&

mkdir -vp /usr/share/doc/git-2.10.1/howto/{html,text}             &&
mv        /usr/share/doc/git-2.10.1/howto/{*.txt,text}            &&
mv        /usr/share/doc/git-2.10.1/howto/{*.,}html
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
