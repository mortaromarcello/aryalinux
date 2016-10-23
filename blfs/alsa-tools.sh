#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The ALSA Tools package containsbr3ak advanced tools for certain sound cards.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:alsa-lib
#OPT:gtk2
#OPT:gtk3
#OPT:fltk


#VER:alsa-tools:1.1.0


NAME="alsa-tools"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://alsa.cybermirror.org/tools/alsa-tools-1.1.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/alsa-tools/alsa-tools-1.1.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-tools/alsa-tools-1.1.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/alsa-tools/alsa-tools-1.1.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/alsa-tools/alsa-tools-1.1.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/alsa-tools/alsa-tools-1.1.0.tar.bz2 || wget -nc ftp://ftp.alsa-project.org/pub/tools/alsa-tools-1.1.0.tar.bz2


URL=http://alsa.cybermirror.org/tools/alsa-tools-1.1.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root


rm -rf qlo10k1 Makefile gitcompile


for tool in *
do
  case $tool in
    seq )
      tool_dir=seq/sbiload
    ;;
    * )
      tool_dir=$tool
    ;;
  esac
  pushd $tool_dir
    ./configure --prefix=/usr
    make "-j`nproc`"
    as_root make install
    as_root /sbin/ldconfig
  popd
done
unset tool tool_dir




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST