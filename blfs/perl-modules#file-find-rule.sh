#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-modules#number-compare
#REQ:perl-modules#text-glob

URL="http://search.cpan.org/CPAN/authors/id/R/RC/RCLAMP/File-Find-Rule-0.34.tar.gz"

#VER:File-Find-Rule:0.34

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

echo "perl-modules#file-find-rule=>`date`" | sudo tee -a $INSTALLED_LIST

