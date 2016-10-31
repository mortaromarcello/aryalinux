#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:Font-TTF:1.05

URL=http://search.cpan.org/CPAN/authors/id/M/MH/MHOSKEN/Font-TTF-1.05.tar.gz

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

echo "perl-modules#font-ttf=>`date`" | sudo tee -a $INSTALLED_LIST
