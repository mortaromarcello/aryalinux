#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#NAME:perl-modules#perl-uri


cd $SOURCE_DIR
wget -nc http://www.cpan.org/authors/id/E/ET/ETHER/URI-1.65.tar.gz

TARBALL="URI-1.65.tar.gz"
SRC_DIR="`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `"

cd $SOURCE_DIR
tar -xf $TARBALL
cd $SRC_DIR

perl Makefile.PL &&
make &&
sudo make install


cd $SOURCE_DIR
rm -rf $SRC_DIR

echo "perl-modules#perl-uri=>`date`" | sudo tee -a $INSTALLED_LIST
