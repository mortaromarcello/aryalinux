#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:vim:7.4

#REC:gtk2
#REC:xorg-server
#OPT:gpm
#OPT:lua
#OPT:python2
#OPT:ruby
#OPT:tcl


cd $SOURCE_DIR

URL=http://vim.mirror.fr/unix//vim-7.4.tar.bz2

wget -nc http://vim.mirror.fr/unix//vim-7.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vim/vim-7.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vim/vim-7.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vim/vim-7.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vim/vim-7.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vim/vim-7.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

echo '#define SYS_VIMRC_FILE  "/etc/vimrc"' >>  src/feature.h &&
echo '#define SYS_GVIMRC_FILE "/etc/gvimrc"' >> src/feature.h &&
./configure --prefix=/usr --with-features=huge                &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -snfv ../vim/vim74/doc /usr/share/doc/vim-7.4

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


rsync -avzcP --delete --exclude="/dos/" --exclude="/spell/" \
    ftp.nluug.nl::Vim/runtime/ ./runtime/



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C src installruntime &&
vim -c ":helptags /usr/share/doc/vim-7.4" -c ":q"

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
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

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "vim=>`date`" | sudo tee -a $INSTALLED_LIST

