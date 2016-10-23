#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Vim package, which is anbr3ak abbreviation for VI IMproved, contains a <span class="command"><strong>vi</strong> clone with extra features asbr3ak compared to the original <span class="command"><strong>vi</strong>.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#REC:gtk2
#REC:xorg-server
#OPT:gpm
#OPT:lua
#OPT:python2
#OPT:ruby
#OPT:tcl


#VER:vim:8.0


NAME="vim"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vim/vim-8.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vim/vim-8.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vim/vim-8.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vim/vim-8.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vim/vim-8.0.tar.bz2 || wget -nc http://ftp.vim.org/vim/unix/vim-8.0.tar.bz2


URL=http://ftp.vim.org/vim/unix/vim-8.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

echo '#define SYS_VIMRC_FILE  "/etc/vimrc"' >>  src/feature.h &&
echo '#define SYS_GVIMRC_FILE "/etc/gvimrc"' >> src/feature.h &&
./configure --prefix=/usr \
            --with-features=huge \
            --with-tlib=ncursesw &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -snfv ../vim/vim80/doc /usr/share/doc/vim-8.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


rsync -avzcP --delete --exclude="/dos/" --exclude="/spell/" \
    ftp.nluug.nl::Vim/runtime/ ./runtime/



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C src installruntime &&
vim -c ":helptags /usr/share/doc/vim-8.0" -c ":q"

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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST