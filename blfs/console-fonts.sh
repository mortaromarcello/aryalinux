#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions




cd $SOURCE_DIR

whoami > /tmp/currentuser

setfont /path/to/yourfont.ext


setfont gr737a-9x16


showconsolefont


make psf


install -v -m644 ter-v32n.psf.gz /usr/share/consolefonts


cd $SOURCE_DIR

echo "console-fonts=>`date`" | sudo tee -a $INSTALLED_LIST

