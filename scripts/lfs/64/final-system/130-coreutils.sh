#!/bin/bash

set -e
set +h

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=coreutils-8.22.tar.xz

if ! grep 131-coreutils $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../coreutils-8.22-uname-1.patch

FORCE_UNSAFE_CONFIGURE=1 \
  ./configure --prefix=/usr \
    --enable-no-install-program=kill,uptime \
    --enable-install-program=hostname --libexecdir=/usr/lib

make "-j`nproc`"

make install

mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date} /bin
mv -v /usr/bin/{dd,df,echo,false,hostname,ln,ls,mkdir,mknod} /bin
mv -v /usr/bin/{mv,pwd,rm,rmdir,stty,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin

cd $SOURCE_DIR
rm -rf $DIR
echo 131-coreutils >> $LOG

fi
