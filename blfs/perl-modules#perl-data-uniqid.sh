#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf


URL="http://www.linuxfromscratch.org/patches/blfs/systemd/Data-Uniqid-0.12-disable_failing_test-1.patch"

#VER:Data-Uniqid-0.2-disable_failing_test-.patch:1

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

echo "perl-modules#perl-data-uniqid=>`date`" | sudo tee -a $INSTALLED_LIST

