#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions




cd $SOURCE_DIR

whoami > /tmp/currentuser

./configure --prefix=/usr


cat > $LFS/etc/group << "EOF"
root:x:0:
bin:x:1:
......
EOF


cd $SOURCE_DIR

echo "conventions=>`date`" | sudo tee -a $INSTALLED_LIST

