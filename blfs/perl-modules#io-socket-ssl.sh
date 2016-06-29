#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-modules#io-socket-ssl
#REQ:perl-modules#mozilla-ca

URL="http://search.cpan.org/CPAN/authors/id/S/SU/SULLR/IO-Socket-SSL-2.029.tar.gz"

#VER:IO-Socket-SSL:2.029

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

echo "perl-modules#io-socket-ssl=>`date`" | sudo tee -a $INSTALLED_LIST

