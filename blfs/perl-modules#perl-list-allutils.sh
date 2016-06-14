#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-modules#perl-list-moreutils
#REQ:perl-modules#number-compare
#REQ:perl-modules#test-warnings
#REQ:perl-modules#text-glob

URL="http://www.cpan.org/authors/id/D/DR/DROLSKY/List-AllUtils-0.09.tar.gz"

#VER:List-AllUtils:0.09

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

echo "perl-modules#perl-list-allutils=>`date`" | sudo tee -a $INSTALLED_LIST

