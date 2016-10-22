#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:perl-modules#perl-module-build
#REQ:perl-modules#perl-file-which
#REQ:perl-modules#ipc-system-simple

URL="http://www.cpan.org/authors/id/K/KI/KIMRYAN/File-BaseDir-0.07.tar.gz"

#VER:File-BaseDir:0.07

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

echo "perl-modules#perl-file-basedir=>`date`" | sudo tee -a $INSTALLED_LIST

