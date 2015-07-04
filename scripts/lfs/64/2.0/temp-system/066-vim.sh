#!/bin/bash

set -e

. inputs

export SOURCE_DIR=/mnt/clfs/sources
export LOG=/mnt/clfs/sources/build-log

cd $SOURCE_DIR
touch $LOG

TAR=vim-7.4.tar.bz2

if ! grep 067-vim $LOG
then

DIR=`tar -tf $SOURCE_DIR/$TAR | cut -d/ -f1 | uniq`
tar -xf $TAR
cd $DIR


patch -Np1 -i ../vim-7.4-branch_update-7.patch

cat > src/auto/config.cache << "EOF"
vim_cv_getcwd_broken=no
vim_cv_memmove_handles_overlap=yes
vim_cv_stat_ignores_slash=no
vim_cv_terminfo=yes
vim_cv_toupper_broken=no
vim_cv_tty_group=world
EOF

echo '#define SYS_VIMRC_FILE "/tools/etc/vimrc"' >> src/feature.h

./configure --build=${CLFS_HOST} --host=${CLFS_TARGET} \
    --prefix=/tools --enable-gui=no --disable-gtktest --disable-xim \
    --disable-gpm --without-x --disable-netbeans --with-tlib=ncurses

make "-j`nproc`"

make install

ln -sv vim /tools/bin/vi

cat > /tools/etc/vimrc << "EOF"
<code class="literal">" Begin /tools/etc/vimrc

set nocompatible
set backspace=2
set ruler
syntax on

" End /tools/etc/vimrc</code>
EOF

cd $SOURCE_DIR
rm -rf $DIR
echo 067-vim >> $LOG

fi
