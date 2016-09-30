#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:filezilla:3.18.0

#REQ:wxwidgets
#REQ:libfilezilla

cd $SOURCE_DIR

URL=http://heanet.dl.sourceforge.net/project/filezilla/FileZilla_Client/3.18.0/FileZilla_3.18.0_src.tar.bz2
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --with-pugixml=builtin &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "filezilla=>`date`" | sudo tee -a $INSTALLED_LIST


