#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-modules#mime-charset

URL="http://www.cpan.org/authors/id/N/NE/NEZUMI/Unicode-LineBreak-2016.003.tar.gz"

#VER:Unicode-LineBreak:2016.003

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

echo "perl-modules#perl-unicode-linebreak=>`date`" | sudo tee -a $INSTALLED_LIST

