#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






cat > 1434987998774.sh << "ENDOFFILE"
mkdir          /srv/cvsroot &&
chmod 1777     /srv/cvsroot &&
export CVSROOT=/srv/cvsroot &&
cvs init
ENDOFFILE
chmod a+x 1434987998774.sh
sudo ./1434987998774.sh
sudo rm -rf 1434987998774.sh

cd <em class="replaceable"><code><sourcedir></em> &&
cvs import -m "<em class="replaceable"><code><repository test></em>" <em class="replaceable"><code><cvstest></em> <em class="replaceable"><code><vendortag></em> <em class="replaceable"><code><releasetag></em>

cvs co cvstest

export CVS_RSH=/usr/bin/ssh &&
cvs -d:ext:<em class="replaceable"><code><servername></em>:/srv/cvsroot co cvstest

cat > 1434987998774.sh << "ENDOFFILE"
(grep anonymous /etc/passwd || useradd anonymous -s /bin/false -u 98) &&
echo anonymous: > /srv/cvsroot/CVSROOT/passwd &&
echo anonymous > /srv/cvsroot/CVSROOT/readers
ENDOFFILE
chmod a+x 1434987998774.sh
sudo ./1434987998774.sh
sudo rm -rf 1434987998774.sh

cvs -d:pserver:anonymous@<em class="replaceable"><code><servername></em>:/srv/cvsroot co cvstest


 
cd $SOURCE_DIR
 
echo "cvsserver=>`date`" | sudo tee -a $INSTALLED_LIST