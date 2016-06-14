#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-modules#encode-locale
#REQ:perl-modules#perl-uri
#REQ:perl-modules#http-cookies
#REQ:perl-modules#http-negotiate
#REQ:perl-modules#net-http
#REQ:perl-modules#www-robotrules
#REQ:perl-modules#http-daemon
#REQ:perl-modules#file-listing

URL="https://cpan.metacpan.org/authors/id/E/ET/ETHER/libwww-perl-6.15.tar.gz"

#VER:libwww-perl:6.15

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

echo "perl-modules#perl-lwp=>`date`" | sudo tee -a $INSTALLED_LIST

