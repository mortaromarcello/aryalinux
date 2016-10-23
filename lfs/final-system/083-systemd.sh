#!/bin/bash

set -e
set +h

. /sources/build-properties

if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
	export MAKEFLAGS="-j `nproc`"
fi

SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="083-systemd.sh"
TARBALL="systemd-231.tar.xz"

echo "$LOGLENGTH" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	tar xf $TARBALL
	cd $DIRECTORY
fi

sed -i "s:blkid/::" $(grep -rl "blkid/blkid.h")
sed -e 's@test/udev-test.pl @@'  \
    -e 's@test-copy$(EXEEXT) @@' \
    -i Makefile.in
patch -Np1 -i ../systemd-231-security_fix-1.patch
cat > config.cache << "EOF"
KILL=/bin/kill
MOUNT_PATH=/bin/mount
UMOUNT_PATH=/bin/umount
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include/blkid"
HAVE_LIBMOUNT=1
MOUNT_LIBS="-lmount"
MOUNT_CFLAGS="-I/tools/include/libmount"
cc_cv_CFLAGS__flto=no
XSLTPROC="/usr/bin/xsltproc"
EOF
./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var     \
            --config-cache           \
            --with-rootprefix=       \
            --with-rootlibdir=/lib   \
            --enable-split-usr       \
            --disable-firstboot      \
            --disable-ldconfig       \
            --disable-sysusers       \
            --without-python         \
            --with-default-dnssec=no \
            --docdir=/usr/share/doc/systemd-231
make LIBRARY_PATH=/tools/lib
make LD_LIBRARY_PATH=/tools/lib install
mv -v /usr/lib/libnss_{myhostname,mymachines,resolve}.so.2 /lib
rm -rfv /usr/lib/rpm
for tool in runlevel reboot shutdown poweroff halt telinit; do
     ln -sfv ../bin/systemctl /sbin/${tool}
done
ln -sfv ../lib/systemd/systemd /sbin/init
systemd-machine-id-setup
rm -fv /etc/resolv.conf
# ln -sv /run/systemd/resolve/resolv.conf /etc/resolv.conf


cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
