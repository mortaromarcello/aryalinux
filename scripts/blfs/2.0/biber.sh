#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:perl-modules#perl-autovivification
#DEP:perl-modules#perl-business-isbn
#DEP:perl-modules#perl-business-ismn
#DEP:perl-modules#perl-business-issn
#DEP:perl-modules#perl-data-compare
#DEP:perl-modules#perl-date-simple
#DEP:perl-modules#perl-encode-eucjpascii
#DEP:perl-modules#perl-encode-hanextra
#DEP:perl-modules#perl-encode-jis2k
#DEP:perl-modules#perl-file-slurp
#DEP:perl-modules#perl-ipc-run3
#DEP:perl-modules#perl-log-log4perl
#DEP:perl-modules#perl-lwp
#DEP:perl-modules#perl-list-allutils
#DEP:perl-modules#perl-regexp-common
#DEP:perl-modules#perl-text-bibtex
#DEP:perl-modules#perl-unicode-collate
#DEP:perl-modules#perl-unicode-linebreak
#DEP:perl-modules#perl-xml-libxml-simple
#DEP:perl-modules#perl-xml-libxslt
#DEP:perl-modules#perl-xml-writer
#DEP:texlive
#DEP:perl-modules#perl-readonly-xs
#DEP:perl-modules#perl-file-which


cd $SOURCE_DIR

wget -nc http://sourceforge.net/projects/biblatex-biber/files/biblatex-biber/1.9/biblatex-biber.tar.gz
wget -nc http://sourceforge.net/projects/biblatex/files/biblatex-2.9/biblatex-2.9a.tds.tgz


TARBALL=biblatex-biber.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's/use Encode;/&\nuse File::Slurp;\nuse File::Spec;/' \
  lib/Biber/LaTeX/Recode.pm &&
perl ./Build.PL &&
./Build.PL

cat > 1434987998844.sh << "ENDOFFILE"
tar -xf ../biblatex-2.9a.tds.tgz -C /opt/texlive/2014/texmf-dist &&
texhash &&
./Build install
ENDOFFILE
chmod a+x 1434987998844.sh
sudo ./1434987998844.sh
sudo rm -rf 1434987998844.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "biber=>`date`" | sudo tee -a $INSTALLED_LIST