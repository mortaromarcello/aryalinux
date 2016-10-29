#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions


URL="http://search.cpan.org/CPAN/authors/id/S/SH/SHLOMIF/XML-LibXML-2.0128.tar.gz"

NAME="XML-LibXML"
VERSION="2.0128"

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

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
