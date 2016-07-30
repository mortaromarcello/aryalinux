#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:.._postlfs_openssl#REQ:perl-modules#perl-lwp
#REQ:perl-modules#io-socket-ssl

URL="http://www.cpan.org/authors/id/M/MS/MSCHILLI/LWP-Protocol-https-6.06.tar.gz"

#VER:LWP-Protocol-https:6.06

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

echo "perl-modules#perl-lwp-protocol-https=>`date`" | sudo tee -a $INSTALLED_LIST

