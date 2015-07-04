#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






cat > 1434987998792.sh << "ENDOFFILE"
usermod -a -G video <em class="replaceable"><code><username></em>
ENDOFFILE
chmod a+x 1434987998792.sh
sudo ./1434987998792.sh
sudo rm -rf 1434987998792.sh

DRI_PRIME=1 glxinfo | egrep "(OpenGL vendor|OpenGL renderer|OpenGL version)"

cat > 1434987998792.sh << "ENDOFFILE"
install -v -d -m755 /usr/share/fonts/dejavu &&
install -v -m644 *.ttf /usr/share/fonts/dejavu &&
fc-cache -v /usr/share/fonts/dejavu
ENDOFFILE
chmod a+x 1434987998792.sh
sudo ./1434987998792.sh
sudo rm -rf 1434987998792.sh

cat > /etc/X11/xorg.conf.d/xkb-defaults.conf << "EOF"
Section "InputClass"
    Identifier "XKB Defaults"
    MatchIsKeyboard "yes"
    Option "XkbOptions" "terminate:ctrl_alt_bksp"
EndSection
EOF

cat > /etc/X11/xorg.conf.d/videocard-0.conf << "EOF"
Section "Device"
    Identifier  "Videocard0"
    Driver      "radeon"
    VendorName  "Videocard vendor"
    BoardName   "ATI Radeon 7500"
    Option      "NoAccel" "true"
EndSection
EOF

cat > /etc/X11/xorg.conf.d/server-layout.conf << "EOF"
Section "ServerLayout"
    Identifier     "DefaultLayout"
    Screen      0  "Screen0" 0 0
    Screen      1  "Screen1" LeftOf "Screen0"
    Option         "Xinerama"
EndSection
EOF


 
cd $SOURCE_DIR
 
echo "xorg-config=>`date`" | sudo tee -a $INSTALLED_LIST