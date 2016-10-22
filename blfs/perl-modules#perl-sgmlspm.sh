#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf


URL="http://anduin.linuxfromscratch.org/BLFS/perl-modules/SGMLSpm-1.1.tar.gz"

#VER:SGMLSpm:1.1

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

echo "perl-modules#perl-sgmlspm=>`date`" | sudo tee -a $INSTALLED_LIST

