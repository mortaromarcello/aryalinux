#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libglade
#DEP:shared-mime-info


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/rox/rox-filer-2.11.tar.bz2


TARBALL=rox-filer-2.11.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cd ROX-Filer                                                        &&
sed -i 's:g_strdup(getenv("APP_DIR")):"/usr/share/rox":' src/main.c &&

mkdir build                        &&
pushd build                        &&
  ../src/configure LIBS="-lm -ldl" &&
  make                             &&
popd

cat > 1434987998830.sh << "ENDOFFILE"
mkdir -p /usr/share/rox                              &&
cp -av Help Messages Options.xml ROX images style.css .DirIcon /usr/share/rox &&

cp -av ../rox.1 /usr/share/man/man1                  &&
cp -v  ROX-Filer /usr/bin/rox                        &&
chown -Rv root:root /usr/bin/rox /usr/share/rox      &&

cd /usr/share/rox/ROX/MIME                           &&
ln -sv text-x-{diff,patch}.png                       &&
ln -sv application-x-font-{afm,type1}.png            &&
ln -sv application-xml{,-dtd}.png                    &&
ln -sv application-xml{,-external-parsed-entity}.png &&
ln -sv application-{,rdf+}xml.png                    &&
ln -sv application-x{ml,-xbel}.png                   &&
ln -sv application-{x-shell,java}script.png          &&
ln -sv application-x-{bzip,xz}-compressed-tar.png    &&
ln -sv application-x-{bzip,lzma}-compressed-tar.png  &&
ln -sv application-x-{bzip-compressed-tar,lzo}.png   &&
ln -sv application-x-{bzip,xz}.png                   &&
ln -sv application-x-{gzip,lzma}.png                 &&
ln -sv application-{msword,rtf}.png
ENDOFFILE
chmod a+x 1434987998830.sh
sudo ./1434987998830.sh
sudo rm -rf 1434987998830.sh

cat > /path/to/hostname/AppRun << "HERE_DOC"
#!/bin/bash

MOUNT_PATH="${0%/*}"
HOST=${MOUNT_PATH##*/}
export MOUNT_PATH HOST
sshfs -o nonempty ${HOST}:/ ${MOUNT_PATH}
rox -x ${MOUNT_PATH}
HERE_DOC

chmod 755 /path/to/hostname/AppRun

cat > 1434987998830.sh << "ENDOFFILE"
cat > /usr/bin/myumount << "HERE_DOC" &&
#!/bin/bash
sync
if mount | grep "${@}" | grep -q fuse
then fusermount -u "${@}"
else umount "${@}"
fi
HERE_DOC

chmod 755 /usr/bin/myumount
ENDOFFILE
chmod a+x 1434987998830.sh
sudo ./1434987998830.sh
sudo rm -rf 1434987998830.sh

cat > 1434987998830.sh << "ENDOFFILE"
ln -s ../rox/.DirIcon /usr/share/pixmaps/rox.png &&
mkdir -p /usr/share/applications &&

cat > /usr/share/applications/rox.desktop << "HERE_DOC"
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=Rox
Comment=The Rox File Manager
Icon=rox
Exec=rox
Categories=GTK;Utility;Application;System;Core;
StartupNotify=true
Terminal=false
HERE_DOC
ENDOFFILE
chmod a+x 1434987998830.sh
sudo ./1434987998830.sh
sudo rm -rf 1434987998830.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "rox-filer=>`date`" | sudo tee -a $INSTALLED_LIST