#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






cat > 1434987998843.sh << "ENDOFFILE"
export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&

cat >> /etc/profile.d/extrapaths.sh << EOF
pathappend /opt/texlive/2014/texmf-dist/doc/man  MANPATH
pathappend /opt/texlive/2014/texmf-dist/doc/info INFOPATH
pathappend /opt/texlive/2014/bin/$TEXARCH
EOF

unset TEXARCH
ENDOFFILE
chmod a+x 1434987998843.sh
sudo ./1434987998843.sh
sudo rm -rf 1434987998843.sh


 
cd $SOURCE_DIR
 
echo "tex-path=>`date`" | sudo tee -a $INSTALLED_LIST