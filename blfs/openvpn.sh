#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="openvpn_.orig"
VERSION="2.3.7"

#REQ:liblzo2

URL=http://archive.ubuntu.com/ubuntu/pool/main/o/openvpn/openvpn_2.3.7.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --enable-systemd &&
make "-j`nproc`"
sudo make install
sudo mkdir -pv /var/run/openvpn/
sudo cp ./distro/systemd/openvpn-client@.service /lib/systemd/system/
sudo cp ./distro/systemd/openvpn-server@.service /lib/systemd/system/
sudo systemctl enable openvpn-client@.service

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
