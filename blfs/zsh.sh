#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:zsh-doc:5.2
#VER:zsh:5.2

#OPT:libcap
#OPT:pcre
#OPT:valgrind


cd $SOURCE_DIR

URL=http://www.zsh.org/pub/zsh-5.2.tar.xz

wget -nc http://www.zsh.org/pub/zsh-5.2-doc.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/zsh/zsh-5.2-doc.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/zsh/zsh-5.2-doc.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/zsh/zsh-5.2-doc.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/zsh/zsh-5.2-doc.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/zsh/zsh-5.2-doc.tar.xz
wget -nc http://www.zsh.org/pub/zsh-5.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/zsh/zsh-5.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/zsh/zsh-5.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/zsh/zsh-5.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/zsh/zsh-5.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/zsh/zsh-5.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

tar --strip-components=1 -xvf ../zsh-5.2-doc.tar.xz


./configure --prefix=/usr         \
            --bindir=/bin         \
            --sysconfdir=/etc/zsh \
            --enable-etcdir=/etc/zsh                  &&
make                                                  &&
makeinfo  Doc/zsh.texi --plaintext -o Doc/zsh.txt     &&
makeinfo  Doc/zsh.texi --html      -o Doc/html        &&
makeinfo  Doc/zsh.texi --html --no-split --no-headers -o Doc/zsh.html


texi2pdf  Doc/zsh.texi -o Doc/zsh.pdf



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                              &&
make infodir=/usr/share/info install.info &&
install -v -m755 -d                 /usr/share/doc/zsh-5.2/html &&
install -v -m644 Doc/html/*         /usr/share/doc/zsh-5.2/html &&
install -v -m644 Doc/zsh.{html,txt} /usr/share/doc/zsh-5.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make htmldir=/usr/share/doc/zsh-5.2/html install.html &&
install -v -m644 Doc/zsh.dvi /usr/share/doc/zsh-5.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 Doc/zsh.pdf /usr/share/doc/zsh-5.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /usr/lib/libpcre.so.* /lib &&
ln -v -sf ../../lib/libpcre.so.0 /usr/lib/libpcre.so
mv -v /usr/lib/libgdbm.so.* /lib &&
ln -v -sf ../../lib/libgdbm.so.3 /usr/lib/libgdbm.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/shells << "EOF"
/bin/zsh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "zsh=>`date`" | sudo tee -a $INSTALLED_LIST

