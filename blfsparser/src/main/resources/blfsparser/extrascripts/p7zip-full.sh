#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=http://liquidtelecom.dl.sourceforge.net/project/p7zip/p7zip/9.38.1/p7zip_9.38.1_src_all.tar.bz2
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cp makefile.linux_amd64 makefile.machine
make all3
sed -i 's@DEST_HOME=/usr/local@DEST_HOME=/usr@g' install.sh
sudo ./install.sh

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "p7zip-full=>`date`" | sudo tee -a $INSTALLED_LIST


