#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="%DESCRIPTION%"
SECTION="pst"
NAME="tex-path"





URL=
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&
cat >> /etc/profile.d/extrapaths.sh << EOF

# Begin texlive addition
pathappend /opt/texlive/2016/texmf-dist/doc/man MANPATH
pathappend /opt/texlive/2016/texmf-dist/doc/info INFOPATH
pathappend /opt/texlive/2016/bin/$TEXARCH
# End texlive addition

EOF
unset TEXARCH

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
