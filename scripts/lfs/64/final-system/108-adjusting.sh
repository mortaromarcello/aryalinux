#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

#TAR=null

if ! grep 109-adjusting $LOG
then

#DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
#tar -xf $TAR
#cd $DIR


gcc -dumpspecs | \
perl -p -e 's@/tools/lib/ld@/lib/ld@g;' \
     -e 's@\*startfile_prefix_spec:\n@$_/usr/lib/ @g;' > \
     $(dirname $(gcc --print-libgcc-file-name))/specs

echo 'main(){}' > dummy.c
gcc dummy.c
readelf -l a.out | grep ': /lib'

rm -v dummy.c a.out

cd $SOURCE_DIR
#rm -rf $DIR
echo 109-adjusting >> $LOG

fi
