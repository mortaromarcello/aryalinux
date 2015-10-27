#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/fuse/fuse-2.9.3.tar.gz


TARBALL=fuse-2.9.3.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static INIT_D_PATH=/tmp/init.d &&
make

cat > 1434987998751.sh << "ENDOFFILE"
make install &&

mv -v   /usr/lib/libfuse.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libfuse.so) /usr/lib/libfuse.so &&
rm -rf  /tmp/init.d &&

install -v -dm755 /usr/share/doc/fuse-2.9.3 &&
install -v -m644  doc/{how-fuse-works,kernel.txt} \
                  /usr/share/doc/fuse-2.9.3
ENDOFFILE
chmod a+x 1434987998751.sh
sudo ./1434987998751.sh
sudo rm -rf 1434987998751.sh

cat > 1434987998751.sh << "ENDOFFILE"
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
ENDOFFILE
chmod a+x 1434987998751.sh
sudo ./1434987998751.sh
sudo rm -rf 1434987998751.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "fuse=>`date`" | sudo tee -a $INSTALLED_LIST