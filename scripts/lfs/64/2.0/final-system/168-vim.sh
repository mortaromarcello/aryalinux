#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/sources
export LOG=/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=vim-7.4.tar.bz2

if ! grep 169-vim $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../vim-7.4-branch_update-7.patch

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

./configure --prefix=/usr

make "-j`nproc`"

make install

ln -sv vim /usr/bin/vi

ln -sv ../vim/vim74/doc /usr/share/doc/vim-7.4

cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

set nocompatible
set backspace=2
set ruler
syntax on
if (&term == "iterm") || (&term == "putty")
 set background=dark
endif

" End /etc/vimrc
EOF

vim -c ':options'

cd $SOURCE_DIR
rm -rf $DIR
echo 169-vim >> $LOG

fi
