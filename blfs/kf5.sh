#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions


#REQ:bluez
#REQ:boost
#REQ:docbook
#REQ:docbook-xsl
#REQ:giflib
#REQ:libepoxy
#REQ:libgcrypt
#REQ:libjpeg
#REQ:libpng
#REQ:libxslt
#REQ:ModemManager
#REQ:networkmanager
#REQ:perl-modules#perl-uri
#REQ:phonon
#REQ:shared-mime-info
#REQ:wget
#REC:avahi
#REC:aspell
#REC:general_libdbusmenu-qt
#REC:polkit-qt
#OPT:oxygen-fonts
#OPT:doxygen
#OPT:python-modules#Jinja2
#OPT:python-modules#PyYAML
#OPT:jasper
#OPT:mitkrb
#OPT:udisks2
#OPT:upower


cd $SOURCE_DIR

whoami > /tmp/currentuser

cat > frameworks-5.18.0.md5 << "EOF"
cf34c6fa2dcad71300592dd393920ff4 attica-5.18.0.tar.xz
909827fc26098c7b4ab48c7228801e16 bluez-qt-5.18.0.tar.xz
1ebfcf3d9ae51024ea619a31de30adbd kapidox-5.18.0.tar.xz
a9044a93fc88324d97108d69b07f7851 karchive-5.18.0.tar.xz
5cfbb6836dbbdeddef9d889cf824f1bd kcodecs-5.18.0.tar.xz
ecd6f03aa5e0bdcfa1a9b17ce1654afe kconfig-5.18.0.tar.xz
1d17806d243683ac89c95352f82b0da3 kcoreaddons-5.18.0.tar.xz
4c40d991d4c96bc128dd7b31449951ea kdbusaddons-5.18.0.tar.xz
765ee80403c552e07cb96aa033c9377d kdnssd-5.18.0.tar.xz
9829e1689fa1ee9e64679e68c5f096d1 kguiaddons-5.18.0.tar.xz
a6bd7a449ccfbbab1a3e400d984ceabe ki18n-5.18.0.tar.xz
d3d51e235dc56f164c79dc4ebc9feb3e kidletime-5.18.0.tar.xz
ebae895f7e81640d183407810c9f04a4 kimageformats-5.18.0.tar.xz
2021d6412691454b794c7929e1f80c17 kitemmodels-5.18.0.tar.xz
4087b80ec96386348da894e1dbd5839b kitemviews-5.18.0.tar.xz
9c1ba124260ae24f8de606440eefd623 kplotting-5.18.0.tar.xz
6e5d05a5cd7f735ad9832e93c2693ea2 kwidgetsaddons-5.18.0.tar.xz
aa8a829b16e4821c12f742aea0476eff kwindowsystem-5.18.0.tar.xz
7527cfdc8aa93e1ada1ebb765d90ab22 modemmanager-qt-5.18.0.tar.xz
ccfb2950c7ae9a1022aba4fa4eb5d5a2 networkmanager-qt-5.18.0.tar.xz
3be0e15864f99da1419d957c2933a8c7 solid-5.18.0.tar.xz
6359c0e401d2c08cdb763bb35f14af75 sonnet-5.18.0.tar.xz
5ffac7ee80aa144de5719cae044878b0 threadweaver-5.18.0.tar.xz
44f96e75953fb3e66ecefc21ffc3b3ff kauth-5.18.0.tar.xz
b09b9d9e5856f21fb6fedcbcd9719c4f kcompletion-5.18.0.tar.xz
405d9660150c84695373c1c323326a98 kcrash-5.18.0.tar.xz
78e56f2cc33d4e8443339e87fec3571b kdoctools-5.18.0.tar.xz
5cce7e6e758e6456455ea57cbb016b33 kpty-5.18.0.tar.xz
80bbcfc184a8fa6a1664be4719966974 kunitconversion-5.18.0.tar.xz
91e25767cadb56b3894ebfff045f7a21 kconfigwidgets-5.18.0.tar.xz
bbdc7503aa7bb3d7be82a5a206520c97 kglobalaccel-5.18.0.tar.xz
f8b4e91bee1edc6abfa1407b160d29d5 kpackage-5.18.0.tar.xz
fe3138bc70494f0da6e6ea6317141860 kservice-5.18.0.tar.xz
00fb63ff7de44bcec9a408b8a1d0f2d5 kdesu-5.18.0.tar.xz
233e21ccdb6c144c68365aac0c36569f kemoticons-5.18.0.tar.xz
de00d3065870c1b2c6d42dff806d44d7 kiconthemes-5.18.0.tar.xz
5dad6d5e6d3d1740d9f10ca05e58c721 kjobwidgets-5.18.0.tar.xz
2f67512dc135ee4f9c87ddb2b02a6e9e kpeople-5.18.0.tar.xz
40435109ce5d9384aaf87d09396cdb4c knotifications-5.18.0.tar.xz
8bf33798f1a0c2099d32ff62adb20ed4 ktextwidgets-5.18.0.tar.xz
15bd67e33adc2fce5fdabb580b4a408a kwallet-5.18.0.tar.xz
057915802467acb7c6b5cb71a38a021a kxmlgui-5.18.0.tar.xz
65100bbdf0f80c21e3f7c25e781fa483 kbookmarks-5.18.0.tar.xz
317bfc7cb41abbaa24f257beceb76501 kio-5.18.0.tar.xz
81cb1261454ed337366661d18841b205 frameworkintegration-5.18.0.tar.xz
ac8cc22f3e7f210e510ce75e1e606412 kdeclarative-5.18.0.tar.xz
9cfef5918e21d8c539464f9e67bd7055 kinit-5.18.0.tar.xz
bcdb6bee371fe46abaff58993f39544d knewstuff-5.18.0.tar.xz
9c57e87d0f13e8bd0e49782b58716b12 knotifyconfig-5.18.0.tar.xz
497e746e8c9c05b50d21e6a6e3541470 kparts-5.18.0.tar.xz
a0fcb3c4d99209a46076ecf084b44fd9 kxmlrpcclient-5.18.0.tar.xz
9867fe7fb968cec64265ce59067a8d7e kcmutils-5.18.0.tar.xz
193f5cfaded513da333a83b5acca3b35 kded-5.18.0.tar.xz
e5186e68ec0afca81ef8248b5a15b8cc kdewebkit-5.18.0.tar.xz
002fa8c6862fc2e59d14fad1a2feb6cb ktexteditor-5.18.0.tar.xz
76be53547d8ffc7b0ab34547c3ef3d15 kactivities-5.18.0.tar.xz
5267dd2cd57ca07d319238a1946e32f2 kdesignerplugin-5.18.0.tar.xz
de179500e7536dadd33a4b4b3a5f9ed1 plasma-framework-5.18.0.tar.xz
51ae529769e7e8566de5c542f264bde2 portingAids/kjs-5.18.0.tar.xz
9a9dbbd563af37470665bef96813b495 portingAids/kdelibs4support-5.18.0.tar.xz
2f41b63b227759650cd1fca3f8bbfc73 portingAids/khtml-5.18.0.tar.xz
dee5aff4f8b0eaf30a0fc5f572086fe7 portingAids/kjsembed-5.18.0.tar.xz
cd11941765848e298327a1d91dc0377b portingAids/kmediaplayer-5.18.0.tar.xz
8bbc29287684b127280a54e620800a96 portingAids/kross-5.18.0.tar.xz
a59141c3aaa3e9f8f846082a9c1c78b9 portingAids/krunner-5.18.0.tar.xz
EOF


mkdir frameworks &&
cd frameworks &&
grep -v '^#' ../frameworks-5.18.0.md5 | awk '{print $2}' | wget -i- -c \
     -B http://download.kde.org/stable/frameworks/5.18/ &&
sed "s:portingAids/::g" ../frameworks-5.18.0.md5 | md5sum -c -


as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root


bash -e


for package in $(grep -v '^#' ../frameworks-5.18.0.md5 | sed "s:portingAids/::g" | awk '{print $2}')
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
  make "-j`nproc`"
  as_root make install
  popd
  rm -rf $packagedir
  as_root /sbin/ldconfig
done


exit


cd $SOURCE_DIR

echo "kf5=>`date`" | sudo tee -a $INSTALLED_LIST

