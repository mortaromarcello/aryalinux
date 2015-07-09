#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:boost
#DEP:docbook
#DEP:docbook-xsl
#DEP:giflib
#DEP:libepoxy
#DEP:libgcrypt
#DEP:libjpeg
#DEP:libpng
#DEP:libxslt
#DEP:networkmanager
#DEP:phonon
#DEP:shared-mime-info
#DEP:wget
#DEP:avahi
#DEP:aspell
#DEP:libdbusmenu-qt
#DEP:polkit-qt


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/frameworks/5.7/
wget -nc ftp://ftp.kde.org/pub/kde/stable/frameworks/5.7/





cat > frameworks-5.7.0.md5 << "EOF"
45edbcf24f65f17f6d00860ae77cbc1e attica-5.7.0.tar.xz
d561bdc39ec7728f696899ab000965e5 kapidox-5.7.0.tar.xz
c811d4ebf158cee741715a06e27ff0cb karchive-5.7.0.tar.xz
bc01fc93692ca2d703e3a659e574163a kcodecs-5.7.0.tar.xz
8589cb01dc2287399f8eb63966f79a84 kconfig-5.7.0.tar.xz
7347d864de95d4b5df03bba93ed22ad5 kcoreaddons-5.7.0.tar.xz
b328dd1478fa5fd3a1e65b299cc7062a kdbusaddons-5.7.0.tar.xz
fb40f8bef645c65cc6680d9c714eecf2 kdnssd-5.7.0.tar.xz
59ddec8e7b1957d2026e13692d76d054 kguiaddons-5.7.0.tar.xz
71cb953acb2a9e7a6106b1e22260801a ki18n-5.7.0.tar.xz
f5df820630498f314ab67d543fd4a7a3 kidletime-5.7.0.tar.xz
d45ee89eabdb1d12a5a76cad60943084 kimageformats-5.7.0.tar.xz
f4be5065077ba4fe7310ce9fa0a8cb46 kitemmodels-5.7.0.tar.xz
6c1ac3c1f806fc4223b0d098005218e6 kitemviews-5.7.0.tar.xz
637609e197e3ed92ae352f86f14d0baf kplotting-5.7.0.tar.xz
cb646b97ced8a20bbb248b2c6366b7c1 kwidgetsaddons-5.7.0.tar.xz
affc59e5e59b151d0dc9f1e95eb49da4 kwindowsystem-5.7.0.tar.xz
fbac640d46ec3e3ff173c12a5c30a072 networkmanager-qt-5.7.0.tar.xz
763c77540a984d28e00be0026aea8b14 solid-5.7.0.tar.xz
efd59a609e5992ae0094399f6b72af3f sonnet-5.7.0.tar.xz
01ce1c8a53bb864288b56454da236296 threadweaver-5.7.0.tar.xz
355a74f81d18f551561459533ddad859 kauth-5.7.0.tar.xz
821eef72d69c49cf5afd0a7793db9f70 kcompletion-5.7.0.tar.xz
a00223a8266634deb16530c09aa5b604 kcrash-5.7.0.tar.xz
65efa563057f08eb25bf626eab5d7345 kdoctools-5.7.0.tar.xz
27da31464d8381c228d8dd1226628659 kpty-5.7.0.tar.xz
6abf99054b392606e4290a24277dfb13 kunitconversion-5.7.0.tar.xz
92e496e9e439d0a4518d2500fa6e51d5 kconfigwidgets-5.7.0.tar.xz
a54ad9ea7f1ed3eb5d8f3f3708e1d78c kglobalaccel-5.7.0.tar.xz
ddb92846ff8b8d4a81e3649b4c4c2672 kpackage-5.7.0.tar.xz
97f50a98baf0464612e9346b0196d8e5 kservice-5.7.0.tar.xz
250d7641fab53f241b8c1a6b586fca28 kdesu-5.7.0.tar.xz
0505fcffffb67aeeff888ead356b3e88 kemoticons-5.7.0.tar.xz
d41b5a4f68e350b1d36e05c99f060e53 kiconthemes-5.7.0.tar.xz
0ac73cbe963296657429d82668801335 kjobwidgets-5.7.0.tar.xz
b610f0a52530f6ced9ea5cc206c39d7a knotifications-5.7.0.tar.xz
bb39ff70f893174be874defd70924f52 ktextwidgets-5.7.0.tar.xz
20174f02ae51be1e3d3d63f8b4dba722 kwallet-5.7.0.tar.xz
8bcf5f6aabff251d3e722216c1ecfff2 kxmlgui-5.7.0.tar.xz
c741e9e3fc6451841a62dc1e7deb6c66 kbookmarks-5.7.0.tar.xz
44d7f2b251cc4725d6ca52007cdd291d kcmutils-5.7.0.tar.xz
2b8c55bc56b2c2fc1948fcf3aa5714fe kio-5.7.0.tar.xz
cee7800425102977c1290869d8280bd1 frameworkintegration-5.7.0.tar.xz
414cb5a4c26c5c3150c2867e29ec0181 kdeclarative-5.7.0.tar.xz
df35cdef22ccd888a22af1291a88eb3f kinit-5.7.0.tar.xz
567dc7bb3520b9e8cf2f92b7afd854f3 knewstuff-5.7.0.tar.xz
ef6469371ce05c59555c33b27aee2ed9 knotifyconfig-5.7.0.tar.xz
0f930b69e7bf0f4477eb509a2bcb9246 kparts-5.7.0.tar.xz
5dfd4efc47839bb89bb1e4a45a651899 kactivities-5.7.0.tar.xz
b1c65c8fb85a6a7bd574694fdb1ec044 kded-5.7.0.tar.xz
3c8027a2eb04cc76bf8dba23cddb88fa kdewebkit-5.7.0.tar.xz
9a2f27c1ee892848bde4d21aaa694d7c ktexteditor-5.7.0.tar.xz
18d291ebba78f4f49404df63b68ede75 kdesignerplugin-5.7.0.tar.xz
0e8c690beeec8da3b9ae9f45ca5c1942 plasma-framework-5.7.0.tar.xz
91a663cdf43e6c5383483e8e9284e1ef portingAids/kjs-5.7.0.tar.xz
8699a1c9a310e75117349b176fb15187 portingAids/kdelibs4support-5.7.0.tar.xz
e7467a0a2af4147e98f285f65e5aa7c1 portingAids/khtml-5.7.0.tar.xz
c5ec56e2460296046bc57714105e5d2c portingAids/kjsembed-5.7.0.tar.xz
333f8c0720a2215c3f6dd8838c9f09a2 portingAids/kmediaplayer-5.7.0.tar.xz
bf81265f94f2f4f7caf710f0432c6e7d portingAids/kross-5.7.0.tar.xz
53a16b6cc0a3c8f4129c030a8041a1f5 portingAids/krunner-5.7.0.tar.xz
EOF

mkdir frameworks &&
cd frameworks &&
grep -v '^#' ../frameworks-5.7.0.md5 | awk '{print $2}' | wget -i- -c \
     -B http://download.kde.org/stable/frameworks/5.7/ &&
sed "s:portingAids/::g" ../frameworks-5.7.0.md5 | md5sum -c -

as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}

export -f as_root

bash -e

for package in $(grep -v '^#' ../frameworks-5.7.0.md5 | sed "s:portingAids/::g" | awk '{print $2}')
do
  packagedir=${package%.tar.xz}
  tar -xf $package
  case $packagedir in
    kdelibs4support-[0-9]* )
      sed -i "s:4.2:4.5:g" $packagedir/cmake/FindDocBookXML4.cmake
    ;;
  esac
  install -dm755 $packagedir/build
  pushd $packagedir/build
  cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX      \
        -DCMAKE_BUILD_TYPE=Release              \
        -DLIB_INSTALL_DIR=lib                   \
        -DBUILD_TESTING=OFF                     \
        -DQT_PLUGIN_INSTALL_DIR=lib/qt5/plugins \
        -DQML_INSTALL_DIR=lib/qt5/qml           \
        -DECM_MKSPECS_INSTALL_DIR=$KF5_PREFIX/share/qt5/mkspecs/modules \
        ..
  make
  as_root make install
  popd
  rm -rf $packagedir
  as_root /sbin/ldconfig
done

exit


 
cd $SOURCE_DIR
 
echo "kf5=>`date`" | sudo tee -a $INSTALLED_LIST