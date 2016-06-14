#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gcc:5.3.0

#REC:dejagnu


cd $SOURCE_DIR

URL=http://ftpmirror.gnu.org/gcc/gcc-5.3.0/gcc-5.3.0.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gcc/gcc-5.3.0.tar.bz2 || wget -nc ftp://ftp.gnu.org/gnu/gcc/gcc-5.3.0/gcc-5.3.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gcc/gcc-5.3.0.tar.bz2 || wget -nc http://ftpmirror.gnu.org/gcc/gcc-5.3.0/gcc-5.3.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gcc/gcc-5.3.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gcc/gcc-5.3.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gcc/gcc-5.3.0.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

mkdir ../gcc-build                                   &&
cd    ../gcc-build                                   &&
../gcc-5.3.0/configure                               \
    --prefix=/usr                                    \
    --disable-multilib                               \
    --with-system-zlib                               \
    --enable-languages=c,c++,fortran,go,objc,obj-c++ &&
make "-j`nproc`"


ulimit -s 32768 &&
make -k check


../gcc-5.3.0/contrib/test_summary



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -pv /usr/share/gdb/auto-load/usr/lib              &&
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib &&
chown -v -R root:root \
    /usr/lib/gcc/*linux-gnu/5.3.0/include{,-fixed}

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -sf ../usr/bin/cpp /lib          &&
ln -v -sf gcc /usr/bin/cc              &&
install -v -dm755 /usr/lib/bfd-plugins &&
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/5.3.0/liblto_plugin.so /usr/lib/bfd-plugins/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gcc=>`date`" | sudo tee -a $INSTALLED_LIST

