#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:installing
#DEP:gtk2


cd $SOURCE_DIR

wget -nc http://vim.mirror.fr/unix//vim-7.4.tar.bz2


TARBALL=vim-7.4.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

echo '#define SYS_VIMRC_FILE  "/etc/vimrc"' >>  src/feature.h &&
echo '#define SYS_GVIMRC_FILE "/etc/gvimrc"' >> src/feature.h &&
./configure --prefix=/usr --with-features=huge                &&
make

cat > 1434987998754.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998754.sh
sudo ./1434987998754.sh
sudo rm -rf 1434987998754.sh

cat > 1434987998754.sh << "ENDOFFILE"
ln -snfv ../vim/vim74/doc /usr/share/doc/vim-7.4
ENDOFFILE
chmod a+x 1434987998754.sh
sudo ./1434987998754.sh
sudo rm -rf 1434987998754.sh

rsync -avzcP --delete --exclude="/dos/" --exclude="/spell/" \
    ftp.nluug.nl::Vim/runtime/ ./runtime/

cat > 1434987998754.sh << "ENDOFFILE"
make -C src installruntime &&
vim -c ":helptags /usr/share/doc/vim-7.4" -c ":q"
ENDOFFILE
chmod a+x 1434987998754.sh
sudo ./1434987998754.sh
sudo rm -rf 1434987998754.sh

cat > 1434987998754.sh << "ENDOFFILE"
cat > /usr/share/applications/gvim.desktop << "EOF"
[Desktop Entry]
Name=GVim Text Editor
Comment=Edit text files
Comment[pt_BR]=Edite arquivos de texto
TryExec=gvim
Exec=gvim -f %F
Terminal=false
Type=Application
Icon=gvim.png
Categories=Utility;TextEditor;
StartupNotify=true
MimeType=text/plain;
EOF
ENDOFFILE
chmod a+x 1434987998754.sh
sudo ./1434987998754.sh
sudo rm -rf 1434987998754.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "vim=>`date`" | sudo tee -a $INSTALLED_LIST