#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

URL=http://aryalinux.org/releases/2016.04/aryalinux-wallpapers-2016.04.tar.gz
wget -nc $URL

sudo tar -xf aryalinux-wallpapers-2016.04.tar.gz -C /

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
