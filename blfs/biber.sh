#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:biblatex-biber:null
#VER:biblatex-.tds:3.5

#REQ:perl-modules#perl-autovivification
#REQ:perl-modules#perl-business-isbn
#REQ:perl-modules#perl-business-ismn
#REQ:perl-modules#perl-business-issn
#REQ:perl-modules#perl-class-accessor
#REQ:perl-modules#perl-data-compare
#REQ:perl-modules#perl-data-dump
#REQ:perl-modules#perl-data-uniqid
#REQ:perl-modules#perl-datetime-calendar-julian
#REQ:perl-modules#perl-datetime-format-builder
#REQ:perl-modules#perl-encode-eucjpascii
#REQ:perl-modules#perl-encode-hanextra
#REQ:perl-modules#perl-encode-jis2k
#REQ:perl-modules#perl-file-slurp
#REQ:perl-modules#perl-ipc-run3
#REQ:perl-modules#perl-lingua-translit
#REQ:perl-modules#perl-list-allutils
#REQ:perl-modules#perl-list-moreutils
#REQ:perl-modules#perl-log-log4perl
#REQ:perl-modules#perl-lwp-protocol-https
#REQ:perl-modules#perl-module-build
#REQ:perl-modules#perl-regexp-common
#REQ:perl-modules#perl-sort-key
#REQ:perl-modules#perl-text-bibtex
#REQ:perl-modules#perl-text-csv
#REQ:perl-modules#perl-text-roman
#REQ:perl-modules#perl-unicode-linebreak
#REQ:perl-modules#perl-xml-libxml-simple
#REQ:perl-modules#perl-xml-libxslt
#REQ:perl-modules#perl-xml-writer
#REQ:texlive
#REQ:tl-installer
#OPT:perl-modules#perl-file-which
#OPT:perl-modules#perl-test-differences


cd $SOURCE_DIR

URL=http://sourceforge.net/projects/biblatex-biber/files/biblatex-biber/current/biblatex-biber.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/biblatex/biblatex-3.5.tds.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/biblatex/biblatex-3.5.tds.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/biblatex/biblatex-3.5.tds.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/biblatex/biblatex-3.5.tds.tgz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/biblatex/biblatex-3.5.tds.tgz || wget -nc http://sourceforge.net/projects/biblatex/files/biblatex-3.5/biblatex-3.5.tds.tgz
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/biblatex-biber/biblatex-biber.tar.gz || wget -nc http://sourceforge.net/projects/biblatex-biber/files/biblatex-biber/current/biblatex-biber.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/biblatex-biber/biblatex-biber.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/biblatex-biber/biblatex-biber.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/biblatex-biber/biblatex-biber.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/biblatex-biber/biblatex-biber.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

perl ./Build.PL &&
./Build



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
tar -xf ../biblatex-3.5.tds.tgz -C /opt/texlive/2016/texmf-dist &&
texhash &&
./Build install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "biber=>`date`" | sudo tee -a $INSTALLED_LIST

