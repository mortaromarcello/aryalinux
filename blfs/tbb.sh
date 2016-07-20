#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:tbb44_20160526oss_src:_0

URL=https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/tbb44_20160526oss_src_0.tgz

cd /opt/

sudo wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

sudo make


echo "tbb=>`date`" | sudo tee -a $INSTALLED_LIST
