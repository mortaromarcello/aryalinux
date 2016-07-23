#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:playonlinux_.orig:4.2.2

#REQ:cabextract
#REQ:curl
#REQ:gnupg
#REQ:icoutils
#REQ:imagemagick
#REQ:mesa
#REQ:netcat
#REQ:p7zip-full
#REQ:wxpython
#REQ:unzip
#REQ:wget
#REQ:wine
#REQ:x7util
#REQ:xterm

URL=http://archive.ubuntu.com/ubuntu/pool/multiverse/p/playonlinux/playonlinux_4.2.2.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

# Copied from slackware slackbuild

sudo chown -R root:root .
find . \
 \( -perm 777 -o -perm 775 -o -perm 711 -o -perm 555 -o -perm 511 \) \
 -exec sudo chmod 755 {} \; -o \
 \( -perm 666 -o -perm 664 -o -perm 600 -o -perm 444 -o -perm 440 -o -perm 400 \) \
 -exec sudo chmod 644 {} \;
find . -name '*~*' -exec sudo rm -rf {} \;

sudo mkdir -pv /usr/share/playonlinux
sudo cp -a * /usr/share/playonlinux

sudo mkdir -pv /usr/share/applications
sudo cp -a /usr/share/playonlinux/etc/PlayOnLinux.desktop /usr/share/applications/PlayOnLinux.desktop

sudo mkdir -pv /usr/share/pixmaps
sudo cp -a /usr/share/playonlinux/etc/playonlinux.png /usr/share/pixmaps/

sudo mkdir -pv /usr/bin
echo "#!/bin/bash" | sudo tee /usr/bin/playonlinux
echo "/usr/share/playonlinux/playonlinux \"\$@\"" | sudo tee -a /usr/bin/playonlinux
sudo chmod 0755 /usr/bin/playonlinux

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "playonlinux=>`date`" | sudo tee -a $INSTALLED_LIST
