#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:fuse:2.9.7

#OPT:doxygen


cd $SOURCE_DIR

URL=https://github.com/libfuse/libfuse/releases/download/fuse-2.9.7/fuse-2.9.7.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fuse/fuse-2.9.7.tar.gz || wget -nc https://github.com/libfuse/libfuse/releases/download/fuse-2.9.7/fuse-2.9.7.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fuse/fuse-2.9.7.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fuse/fuse-2.9.7.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fuse/fuse-2.9.7.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fuse/fuse-2.9.7.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            INIT_D_PATH=/tmp/init.d &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mv -v   /usr/lib/libfuse.so.* /lib &&
ln -sfv ../../lib/libfuse.so.2.9.7 /usr/lib/libfuse.so &&
rm -rf  /tmp/init.d &&
install -v -m755 -d /usr/share/doc/fuse-2.9.7 &&
install -v -m644    doc/{how-fuse-works,kernel.txt} \
                    /usr/share/doc/fuse-2.9.7

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/fuse.conf << "EOF"
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#
#mount_max = 1000
# Allow non-root users to specify the 'allow_other' or 'allow_root'
# mount options.
#
#user_allow_other
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "fuse=>`date`" | sudo tee -a $INSTALLED_LIST

