#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libtirpc


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/rpcbind/rpcbind-0.2.2.tar.bz2


TARBALL=rpcbind-0.2.2.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998782.sh << "ENDOFFILE"
groupadd -g 28 rpc &&
useradd -c "RPC Bind Daemon Owner" -d /dev/null -g rpc \
        -s /bin/false -u 28 rpc
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

sed -i "/servname/s:rpcbind:sunrpc:" src/rpcbind.c &&
sed -i "/error = getaddrinfo/s:rpcbind:sunrpc:" src/rpcinfo.c

./configure --prefix=/usr       \
            --bindir=/sbin      \
            --with-rpcuser=rpc  \
            --enable-warmstarts \
            --with-statedir=/var/lib/rpcbind &&
make

cat > 1434987998782.sh << "ENDOFFILE"
make install &&
install -v -dm755 -o rpc -g rpc /var/lib/rpcbind
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-rpcbind
cd ..
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "rpcbind=>`date`" | sudo tee -a $INSTALLED_LIST