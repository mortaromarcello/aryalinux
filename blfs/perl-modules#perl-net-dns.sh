#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-modules#digest-hmac
#REQ:perl-modules#io-socket-inet6
#REQ:perl-modules#io-socket-inet

URL="http://www.cpan.org/authors/id/N/NL/NLNETLABS/Net-DNS-1.05.tar.gz"

#VER:Net-DNS:1.05

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

echo "perl-modules#perl-net-dns=>`date`" | sudo tee -a $INSTALLED_LIST

