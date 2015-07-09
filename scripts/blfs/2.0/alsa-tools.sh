#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:alsa-lib


cd $SOURCE_DIR

wget -nc http://alsa.cybermirror.org/tools/alsa-tools-1.0.28.tar.bz2
wget -nc ftp://ftp.alsa-project.org/pub/tools/alsa-tools-1.0.28.tar.bz2


TARBALL=alsa-tools-1.0.28.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

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
    make
    as_root make install
    as_root /sbin/ldconfig
  popd

done
unset tool tool_dir


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "alsa-tools=>`date`" | sudo tee -a $INSTALLED_LIST