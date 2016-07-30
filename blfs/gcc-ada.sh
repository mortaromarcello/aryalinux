#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gcc:6.1.0

#REC:dejagnu


cd $SOURCE_DIR

URL=http://ftpmirror.gnu.org/gcc/gcc-6.1.0/gcc-6.1.0.tar.bz2

wget -nc http://ftpmirror.gnu.org/gcc/gcc-6.1.0/gcc-6.1.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gcc/gcc-6.1.0.tar.bz2 || wget -nc ftp://ftp.gnu.org/gnu/gcc/gcc-6.1.0/gcc-6.1.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gcc/gcc-6.1.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gcc/gcc-6.1.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gcc/gcc-6.1.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gcc/gcc-6.1.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make ins-all prefix=/opt/gnat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


PATH_HOLD=$PATH &&
export PATH=/opt/gnat/bin:$PATH_HOLD



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
find /opt/gnat -name ld -exec mv -v {} {}.old \;
find /opt/gnat -name as -exec mv -v {} {}.old \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


mkdir build &&
cd    build &&
../configure               \
    --prefix=/usr          \
    --disable-multilib     \
    --with-system-zlib     \
    --enable-languages=ada &&
make "-j`nproc`"


ulimit -s 32768 &&
make -k check


../contrib/test_summary



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -pv /usr/share/gdb/auto-load/usr/lib              &&
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib &&
chown -v -R root:root \
    /usr/lib/gcc/*linux-gnu/6.1.0/include{,-fixed} \
    /usr/lib/gcc/*linux-gnu/6.1.0/ada{lib,include}

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -rf /opt/gnat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


export PATH=$PATH_HOLD &&
unset PATH_HOLD


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gcc-ada=>`date`" | sudo tee -a $INSTALLED_LIST

