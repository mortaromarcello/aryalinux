#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

URL=http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

perl Makefile.PL
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "perl-modules#io-string=>`date`" | sudo tee -a $INSTALLED_LIST
