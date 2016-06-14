#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-modules#xml-sax
#REQ:perl-modules#xml-sax-expat
#REQ:perl-modules#xml-libxml
#REQ:perl-modules#tie-ixhash

URL="http://cpan.org/authors/id/G/GR/GRANTM/XML-Simple-2.22.tar.gz"

#VER:XML-Simple:2.22

cd $SOURCE_DIR
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

if [ -f Build.PL ]
then
perl Build.PL &&
./Build &&
sudo ./Build install
fi

if [ -f Makefile.PL ]
then
perl Makefile.PL &&
make &&
sudo make install
fi
cd $SOURCE_DIR

sudo rm -rf $DIRECTORY

echo "perl-modules#perl-xml-simple=>`date`" | sudo tee -a $INSTALLED_LIST

