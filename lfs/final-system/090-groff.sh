#!/bin/bash

set -e
set +h

. /sources/build-properties

if [ "x$MULTICORE" == "xy" ] || [ "x$MULTICORE" == "xY" ]
then
	export MAKEFLAGS="-j 1"
fi

SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="090-groff.sh"
TARBALL="groff-1.22.3.tar.gz"

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

PAGE=PAPER_SIZE ./configure --prefix=/usr
make
make install


cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
