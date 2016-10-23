#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Final steps, before starting LXQt.br3ak
#SECTION:lxqt

whoami > /tmp/currentuser

#REQ:openbox
#REQ:xfwm4
#REQ:plasma-all
#REQ:icewm
#REC:sddm
#REC:lxdm
#REC:desktop-file-utils
#REC:shared-mime-info
#REC:xdg-utils
#REC:xscreensaver




NAME="post-install"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi



URL=
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -svfn $LXQT_PREFIX/share/lxqt /usr/share/lxqt &&
cp -v {$LXQT_PREFIX,/usr}/share/xsessions/lxqt.desktop &&
for i in $LXQT_PREFIX/share/applications/*
do
  ln -svf $i /usr/share/applications/
done
for i in $LXQT_PREFIX/share/desktop-directories/*
do
  ln -svf $i /usr/share/desktop-directories/
done
unset i
ldconfig

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
update-mime-database /usr/share/mime          &&
xdg-icon-resource forceupdate --theme hicolor &&
update-desktop-database -q

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat > ~/.xinitrc << "EOF"
dbus-launch --exit-with-session startlxqt
EOF
startx


startx &> ~/.x-session-errors




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
