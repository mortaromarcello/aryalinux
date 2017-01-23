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
STEPNAME="030-python-pysqlite.sh"
TARBALL="pysqlite-2.8.tar.gz"

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

	cd $SOURCE_DIR

	if [ "$TARBALL" != "" ]
	then
		DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
		if [ -d $DIRECTORY ]
		then
			rm -rvf $DIRECTORY 
		fi
		unzip $TARBALL
		cd $DIRECTORY
	fi

#-----------------------------------------------------------------------
python setup.py build
python setup.py install
#-----------------------------------------------------------------------

	cd $SOURCE_DIR
	if [ "$TARBALL" != "" ]
	then
		rm -rvf $DIRECTORY
		rm -rvf {gcc,glibc,binutils}-build
	fi
	echo "$STEPNAME" | tee -a $LOGFILE
fi
