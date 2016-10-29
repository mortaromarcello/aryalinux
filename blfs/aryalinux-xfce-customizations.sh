#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

URL=http://www.aryalinux.org/packages/2015/config.tar.gz
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

sudo tar -xf $TARBALL -C /

sudo cp -rvf /etc/skel/.config ~
sudo chown -R $UID:$UID ~

cd $SOURCE_DIR
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
