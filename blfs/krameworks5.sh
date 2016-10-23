#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:%DESCRIPTION%
#SECTION:kde

whoami > /tmp/currentuser

#REQ:boost
#REQ:extra-cmake-modules
#REQ:docbook
#REQ:docbook-xsl
#REQ:giflib
#REQ:libepoxy
#REQ:libgcrypt
#REQ:libjpeg
#REQ:libpng
#REQ:libxslt
#REQ:lmdb
#REQ:qtwebkit5
#REQ:phonon
#REQ:shared-mime-info
#REQ:perl-modules#perl-uri
#REQ:wget
#REC:aspell
#REC:avahi
#REC:libdbusmenu-qt
#REC:networkmanager
#REC:polkit-qt
#OPT:bluez
#OPT:ModemManager
#OPT:oxygen-fonts
#OPT:noto-fonts
#OPT:doxygen
#OPT:python-modules#Jinja2
#OPT:python-modules#PyYAML
#OPT:jasper
#OPT:mitkrb
#OPT:udisks2
#OPT:upower




NAME="krameworks5"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi



URL=
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

url=http://download.kde.org/stable/frameworks/5.25/
wget -r -nH --cut-dirs=3 -A '*.xz' -np $url


cat > frameworks-5.25.0.md5 << "EOF"
000a8c34e6c4e548f53493c4519c3c1c attica-5.25.0.tar.xz
#043c08482bf7cf951e18d32e16238fb4 extra-cmake-modules-5.25.0.tar.xz
892840e6b323ba1d4687e75678cf9493 kapidox-5.25.0.tar.xz
7205f46ad213e85a736da5f808b5b8df karchive-5.25.0.tar.xz
089c46445618fbc36c11de7eccd61256 kcodecs-5.25.0.tar.xz
03112534b86d98716cf61865d0ea2497 kconfig-5.25.0.tar.xz
25a40738d380e465ae5161cbaa2b282c kcoreaddons-5.25.0.tar.xz
cd6d6dbfc47cb82a7fb0b81adc24aad7 kdbusaddons-5.25.0.tar.xz
31c35cb2b97f150d103484501cc55aca kdnssd-5.25.0.tar.xz
bfba32b6ee6f1288fef0d7156bf81961 kguiaddons-5.25.0.tar.xz
051c7cab151f9d361d6da83968fb68d2 ki18n-5.25.0.tar.xz
aba67367441db87daf4705e5cd0b4449 kidletime-5.25.0.tar.xz
610989615ba775f55bf07f1b5f5b3bf9 kimageformats-5.25.0.tar.xz
83b9a034bbfaedf0cc12191157899006 kitemmodels-5.25.0.tar.xz
324c058163bb418b26d9cba403e5133d kitemviews-5.25.0.tar.xz
6906f6da8a6d680cd86d1ee96f80bf2b kplotting-5.25.0.tar.xz
c4b6185dac9cecd6af6eea3b56f2271f kwidgetsaddons-5.25.0.tar.xz
ae52891201ea66b15d94a4f5a2717a5f kwindowsystem-5.25.0.tar.xz
45b8586afc97200ea687996fc5ce2327 networkmanager-qt-5.25.0.tar.xz
3ca487d5660ee83d0b2165e525ea5795 solid-5.25.0.tar.xz
1863877132650a61510ee37c894a43c5 sonnet-5.25.0.tar.xz
6e0e0668f25d508aca4c527f762e7701 threadweaver-5.25.0.tar.xz
059033f3a41d6733bc92ed6f3fece2ef kauth-5.25.0.tar.xz
ce3839d146dc522a3595085833bf10ea kcompletion-5.25.0.tar.xz
ecf5dde757c1cf5e3d00d3cfe661474d kcrash-5.25.0.tar.xz
9dc819d8f5402b252b71610102685939 kdoctools-5.25.0.tar.xz
904db48ad9e21de2df42738775261b23 kpty-5.25.0.tar.xz
e4a9229d95ae7ebaa094d104eb8bc633 kunitconversion-5.25.0.tar.xz
03bc05f0c72386a143d1b002178f95f6 kconfigwidgets-5.25.0.tar.xz
3cc65c5082a9bdaa2c93ea01323fb814 kservice-5.25.0.tar.xz
8b2a252d99308aece33663cf9522c43a kglobalaccel-5.25.0.tar.xz
237995199b61f5dd48e862c12fe7779e kpackage-5.25.0.tar.xz
f85faafcbdbf994bdb8b4cbcd7c85f03 kdesu-5.25.0.tar.xz
7a38172342fa120969b73d868e2b4211 kemoticons-5.25.0.tar.xz
45eb7f6ad57eca1f2f5ad3d58a56bef8 kiconthemes-5.25.0.tar.xz
edbdaa821afa328331e46e3d959924ca kjobwidgets-5.25.0.tar.xz
4ef30449b46b701ddf6482d36378e1ec knotifications-5.25.0.tar.xz
b7455b06e270b9e057f1ebe137676687 ktextwidgets-5.25.0.tar.xz
d64ee5eb63d0490b36a1cc9c0ebf126d kwallet-5.25.0.tar.xz
5ca8391964c2743c32e3eb46c975943c kxmlgui-5.25.0.tar.xz
73827857016fb3444101929fbd9fcd83 kbookmarks-5.25.0.tar.xz
0077d90029c34f734fb661912f2213d1 kio-5.25.0.tar.xz
c76d293ffa8bcae4771b78e553d26f53 kdeclarative-5.25.0.tar.xz
139af7a01a29e7dbd81f25adae1df9b2 kcmutils-5.25.0.tar.xz
d63e9454ee42955c44cad1cc78a98d44 frameworkintegration-5.25.0.tar.xz
0b8fcc6d1ef2ff1775ec23dfa34b5de6 kinit-5.25.0.tar.xz
2ea7e17162776681193f67d66821182d knewstuff-5.25.0.tar.xz
61f5e3d3095a7b0cb87d1693c9b1ad05 knotifyconfig-5.25.0.tar.xz
52ddaccaa5848bdfb39b241adf32b63a kparts-5.25.0.tar.xz
42881c6c06ff8a3015e2519a31a74866 kactivities-5.25.0.tar.xz
f859f8818fd5f81645bdfb2cf89ee020 kded-5.25.0.tar.xz
2ca6d2a1377adfe68b3fe2560537616f kdewebkit-5.25.0.tar.xz
c34217c409480ac45f48693c72e3ed8a ktexteditor-5.25.0.tar.xz
b3f68ae1839994631b1798db5a30385e kdesignerplugin-5.25.0.tar.xz
b67b2fc56b005b9fd47a9b64cc39bc40 plasma-framework-5.25.0.tar.xz
#df3b50fe7df5b7c409d80b83beb0337f modemmanager-qt-5.25.0.tar.xz
dc439cc6a4b3093cbee780cac616d1b4 kpeople-5.25.0.tar.xz
c4295e2ebab459374b5570d2164a8279 kxmlrpcclient-5.25.0.tar.xz
2e03661752de63494541649158d712fa bluez-qt-5.25.0.tar.xz
12517175cb2a93341bea3c60de105d07 kfilemetadata-5.25.0.tar.xz
3a86a50695f17e5ffca94bf5664c60d7 baloo-5.25.0.tar.xz
#6f7e0a3d91a18fc31c7b4683f1174358 breeze-icons-5.25.0.tar.xz
#71119a9c74516fcdbc80e3a8effa1e5a oxygen-icons5-5.25.0.tar.xz
fbda904a579120cc23eb6ec9bc660f67 kactivities-stats-5.25.0.tar.xz
427349a763c831796b3de0be4b17a019 krunner-5.25.0.tar.xz
d70abca43cbf6e6a6eba9d79830bf1a1 kwayland-5.25.0.tar.xz
7ffd38082aa627f42a9e4830a739f8c6 portingAids/kjs-5.25.0.tar.xz
37284190af0a84cdd2a12636b5b71b2e portingAids/kdelibs4support-5.25.0.tar.xz
e9b1763b2649d7e21e6cda3e0c5773bf portingAids/khtml-5.25.0.tar.xz
f1d0c9a46be19e69a493f75fc8af54e7 portingAids/kjsembed-5.25.0.tar.xz
a844acb7da10a7b23fa50dade3b523c6 portingAids/kmediaplayer-5.25.0.tar.xz
bb96fd634617bcac31974f9b63f41252 portingAids/kross-5.25.0.tar.xz
EOF


as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root


rm -rf /opt/kf5


bash -e


while read -r line; do
    # Get the file name, ignoring comments and blank lines
    if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
    file=$(echo $line | cut -d" " -f2)
    pkg=$(echo $file|sed 's|^.*/||')          # Remove directory
    packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory
    tar -xf $file
    pushd $packagedir
      mkdir build
      cd    build
      cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
            -DCMAKE_PREFIX_PATH=$QT5DIR        \
            -DCMAKE_BUILD_TYPE=Release         \
            -DLIB_INSTALL_DIR=lib              \
            -DBUILD_TESTING=OFF                \
            -Wno-dev ..
      make "-j`nproc`"
      as_root make install
  popd
  as_root rm -rf $packagedir
  as_root /sbin/ldconfig
done < frameworks-5.25.0.md5
exit


mv -v /opt/kf5 /opt/kf5-5.25.0
ln -sfvn kf5-5.25.0 /opt/kf5




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST