#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The Xorg libraries provide librarybr3ak routines that are used within all X Window applications.br3ak"
SECTION="x"
NAME="x7lib"

#REQ:fontconfig
#REQ:libxcb
#OPT:xmlto
#OPT:fop
#OPT:links
#OPT:lynx
#OPT:w3m


cd $SOURCE_DIR

URL=

if [ ! -z $URL ]
then

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

cat > lib-7.7.md5 << "EOF"
c5ba432dd1514d858053ffe9f4737dd8 xtrans-1.3.5.tar.bz2
6d54227082f3aa2c596f0b3a3fbb9175 libX11-1.6.4.tar.bz2
52df7c4c1f0badd9f82ab124fb32eb97 libXext-1.3.3.tar.bz2
d79d9fe2aa55eb0f69b1a4351e1368f7 libFS-1.0.7.tar.bz2
addfb1e897ca8079531669c7c7711726 libICE-1.0.9.tar.bz2
499a7773c65aba513609fe651853c5f3 libSM-1.2.2.tar.bz2
7a773b16165e39e938650bcc9027c1d5 libXScrnSaver-1.2.2.tar.bz2
8f5b5576fbabba29a05f3ca2226f74d3 libXt-1.1.5.tar.bz2
41d92ab627dfa06568076043f3e089e4 libXmu-1.1.2.tar.bz2
769ee12a43611cdebd38094eaf83f3f0 libXpm-3.5.11.tar.bz2
e5e06eb14a608b58746bdd1c0bd7b8e3 libXaw-1.0.13.tar.bz2
07e01e046a0215574f36a3aacb148be0 libXfixes-5.0.3.tar.bz2
f7a218dcbf6f0848599c6c36fc65c51a libXcomposite-0.4.4.tar.bz2
802179a76bded0b658f4e9ec5e1830a4 libXrender-0.9.10.tar.bz2
1e7c17afbbce83e2215917047c57d1b3 libXcursor-1.1.14.tar.bz2
0cf292de2a9fa2e9a939aefde68fd34f libXdamage-1.1.4.tar.bz2
0920924c3a9ebc1265517bdd2f9fde50 libfontenc-1.1.3.tar.bz2
254ee42bd178d18ebc7a73aacfde7f79 libXfont-1.5.2.tar.bz2
331b3a2a3a1a78b5b44cfbd43f86fcfe libXft-2.3.2.tar.bz2
cc0883a898222d50ff79af3f83595823 libXi-1.7.7.tar.bz2
9336dc46ae3bf5f81c247f7131461efd libXinerama-1.1.3.tar.bz2
28e486f1d491b757173dd85ba34ee884 libXrandr-1.5.1.tar.bz2
45ef29206a6b58254c81bea28ec6c95f libXres-1.0.7.tar.bz2
ef8c2c1d16a00bd95b9fdcef63b8a2ca libXtst-1.2.3.tar.bz2
210b6ef30dda2256d54763136faa37b9 libXv-1.0.11.tar.bz2
4cbe1c1def7a5e1b0ed5fce8e512f4c6 libXvMC-1.0.10.tar.bz2
d7dd9b9df336b7dd4028b6b56542ff2c libXxf86dga-1.1.4.tar.bz2
298b8fff82df17304dfdb5fe4066fe3a libXxf86vm-1.1.4.tar.bz2
ba983eba5a9f05d152a0725b8e863151 libdmx-1.1.3.tar.bz2
ace78aec799b1cf6dfaea55d3879ed9f libpciaccess-0.13.4.tar.bz2
4a4cfeaf24dab1b991903455d6d7d404 libxkbfile-1.0.9.tar.bz2
66662e76899112c0f99e22f2fc775a7e libxshmfence-1.2.tar.bz2
EOF


mkdir -pv lib &&
cd lib &&
grep -v '^#' ../lib-7.7.md5 | awk '{print $2}' | wget -i- -c \
    -B http://ftp.x.org/pub/individual/lib/ &&
md5sum -c ../lib-7.7.md5


as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root


grep -A9 summary *make_check.log





for package in $(grep -v '^#' ../lib-7.7.md5 | awk '{print $2}')
do
  packagedir=${package%.tar.bz2}
  tar -xf $package
  pushd $packagedir
  case $packagedir in
    libX11-[0-9]* )
      sed -i "/seems to be moved/s/^/#/" ltmain.sh
      ./configure $XORG_CONFIG
    ;;
    libXfont-[0-9]* )
      ./configure $XORG_CONFIG --disable-devel-docs
    ;;
    libXt-[0-9]* )
      ./configure $XORG_CONFIG \
                  --with-appdefaultdir=/etc/X11/app-defaults
    ;;
    * )
      ./configure $XORG_CONFIG
    ;;
  esac
  make "-j`nproc`" || make
  #make check 2>&1 | tee ../$packagedir-make_check.log
  as_root make install
  popd
  rm -rf $packagedir
  as_root /sbin/ldconfig
done







if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
