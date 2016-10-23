#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-modules#params-util
#REQ:perl-modules#sub-install
#REQ:perl-modules#sub-name

URL="http://search.cpan.org/CPAN/authors/id/D/DR/DROLSKY/Package-DeprecationManager-0.17.tar.gz"

#VER:Package-DeprecationManager:0.17

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

echo "perl-modules#package-deprecationmanager=>`date`" | sudo tee -a $INSTALLED_LIST
