#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=glibc-2.19.tar.xz

if ! grep 108-glibc $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


LINKER=$(readelf -l /tools/bin/bash | sed -n 's@.*interpret.*/tools\(.*\)]$@\1@p')
sed -i "s|libs -o|libs -L/usr/lib -Wl,-dynamic-linker=${LINKER} -o|" \
  scripts/test-installation.pl
unset LINKER

sed -i 's/\\$$(pwd)/`pwd`/' timezone/Makefile

mkdir -v ../glibc-build
cd ../glibc-build

echo "slibdir=/lib" >> configparms

../glibc-2.19/configure --prefix=/usr \
    --disable-profile --enable-kernel=2.6.32 \
    --libexecdir=/usr/lib/glibc --libdir=/usr/lib \
    --enable-obsolete-rpc

make "-j`nproc`"

touch /etc/ld.so.conf

ln -sv ld-2.19.so /lib/ld-linux.so.2

make install &&
rm -v /usr/include/rpcsvc/*.x

rm -v /lib/ld-linux.so.2
sed -i.bak '/RTLDLIST/s%/ld-linux.so.2 /lib64%%' /usr/bin/ldd

rm -v /usr/bin/ldd.bak

cp -v ../glibc-2.19/nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd

install -v -Dm644 ../glibc-2.19/nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf
install -v -Dm644 ../glibc-2.19/nscd/nscd.service /lib/systemd/system/nscd.service

make localedata/install-locales

mkdir -pv /usr/lib/locale
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i ja_JP -f EUC-JP ja_JP

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

tar -xf ../tzdata2014d.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew \
          systemv; do
    zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
    zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
done

cp -v zone.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO

TZ=`tzselect`

cp -v /usr/share/zoneinfo/$TZ \
    /etc/localtime

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf

/usr/local/lib
/opt/lib

# End /etc/ld.so.conf
EOF

cd $SOURCE_DIR
rm -rf $DIR
rm -rf glibc-build

echo 108-glibc >> $LOG

fi
