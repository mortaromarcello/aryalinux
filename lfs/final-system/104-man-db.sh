#!/bin/bash

set -e
set +h

. /sources/build-properties
echo -e "building $0"
if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
	export MAKEFLAGS="-j `nproc`"
fi

SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="104-man-db.sh"
TARBALL="man-db-2.7.5.tar.xz"

echo "$LOGLENGTH" > /sources/lines2track

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	if [ -d $DIRECTORY ]
	then
		rm -rvf $DIRECTORY 
	fi
	tar xvf $TARBALL
	cd $DIRECTORY
fi

./configure --prefix=/usr                        \
            --docdir=/usr/share/doc/man-db-2.7.5 \
            --sysconfdir=/etc                    \
            --disable-setuid                     \
            --with-browser=/usr/bin/lynx         \
            --with-vgrind=/usr/bin/vgrind        \
            --with-grap=/usr/bin/grap
make
make install
sed -i "s:man root:root root:g" /usr/lib/tmpfiles.d/man-db.conf


cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
