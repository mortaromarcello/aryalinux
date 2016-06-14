#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions




cd $SOURCE_DIR


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
useradd -m <em class="replaceable"><code><newuser></em>

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "skel=>`date`" | sudo tee -a $INSTALLED_LIST

