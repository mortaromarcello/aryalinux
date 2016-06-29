#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions




cd $SOURCE_DIR

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&
cat >> /etc/profile.d/extrapaths.sh << EOF

# Begin texlive addition
pathappend /opt/texlive/2015/texmf-dist/doc/man MANPATH
pathappend /opt/texlive/2015/texmf-dist/doc/info INFOPATH
pathappend /opt/texlive/2015/bin/$TEXARCH
# End texlive addition

EOF
unset TEXARCH

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "tex-path=>`date`" | sudo tee -a $INSTALLED_LIST

