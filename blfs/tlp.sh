#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#REQ:unzip
#VER:tlp:SVN`date --iso-8601`

cd $SOURCE_DIR

wget https://github.com/linrunner/TLP/archive/master.zip -O tlp.zip
unzip tlp.zip

cd TLP-master

make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
rm -rf TLP-master

echo "tlp=>`date`" | sudo tee -a $INSTALLED_LIST


