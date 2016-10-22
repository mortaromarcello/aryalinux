#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:docbook-utils:0.6.14

#REQ:openjade
#REQ:docbook-dsssl
#REQ:sgml-dtd-3
#OPT:perl-modules#perl-sgmlspm
#OPT:lynx
#OPT:links
#OPT:w3m


cd $SOURCE_DIR

URL=ftp://sources.redhat.com/pub/docbook-tools/new-trials/SOURCES/docbook-utils-0.6.14.tar.gz

wget -nc http://www.linuxfromscratch.org/patches/downloads/docbook-utils/docbook-utils-0.6.14-grep_fix-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/docbook-utils-0.6.14-grep_fix-1.patch
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook-utils/docbook-utils-0.6.14.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/docbook-utils/docbook-utils-0.6.14.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/docbook-utils/docbook-utils-0.6.14.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/docbook-utils/docbook-utils-0.6.14.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/docbook-utils/docbook-utils-0.6.14.tar.gz || wget -nc ftp://sources.redhat.com/pub/docbook-tools/new-trials/SOURCES/docbook-utils-0.6.14.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../docbook-utils-0.6.14-grep_fix-1.patch &&
sed -i 's:/html::' doc/HTML/Makefile.in                &&
./configure --prefix=/usr --mandir=/usr/share/man      &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
for doctype in html ps dvi man pdf rtf tex texi txt
do
    ln -svf docbook2$doctype /usr/bin/db2$doctype
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "docbook-utils=>`date`" | sudo tee -a $INSTALLED_LIST

