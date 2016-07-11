#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#REQ:cups
#REQ:GConf

cd /opt
sudo git clone https://github.com/scheib/chromium-latest-linux.git
cd chromium-latest-linux
sudo ./update.sh

sudo tee /etc/profile.d/chromium.sh <<"EOF"
export PATH=$PATH:/opt/chromium-latest-linux/latest
EOF

sudo cp -v ./.local/share/applications/chromium-devel.desktop /usr/share/applications/

echo "chromium-bin=>`date`" | sudo tee -a $INSTALLED_LIST
