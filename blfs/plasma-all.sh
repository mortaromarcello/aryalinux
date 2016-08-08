#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions


#REQ:fontforge
#REQ:gtk2
#REQ:gtk3
#REQ:kframeworks5
#REQ:libpwquality
#REQ:libxkbcommon
#REQ:mesa
#REQ:wayland
#REQ:networkmanager
#REQ:pulseaudio
#REQ:python2
#REQ:qca
#REQ:taglib
#REQ:xcb-util-cursor
#REQ:plymouth
#REC:libdbusmenu-qt
#REC:libcanberra
#REC:x7driver
#REC:linux-pam
#REC:lm_sensors
#REC:oxygen-icons5
#REC:pciutils
#OPT:glu
#OPT:x7driver


cd $SOURCE_DIR

whoami > /tmp/currentuser
export KF5_PREFIX=/opt/kf5

url=http://download.kde.org/stable/plasma/5.6.5/
wget -nc -r -nH --cut-dirs=3 -A '*.xz' -np $url


cat > plasma-5.6.5.md5 << "EOF"
30a16a0dd46ca2ce36b7fc09355b485d kde-cli-tools-5.6.5.tar.xz
d979aa9467e7554874681be3f51fd5ce kdecoration-5.6.5.tar.xz
#dd6ad77e5d8bfbcd374f0c2e58d636a8 kwayland-5.6.5.tar.xz
fd556c9aeaf9330bdb7755226875a245 libkscreen-5.6.5.tar.xz
717a38db625198390e17a147d38fc532 libksysguard-5.6.5.tar.xz
8fb2f83fae5c09bbed5e876831af124d breeze-5.6.5.tar.xz
05282eb95af385e5877efd3ee294429a breeze-gtk-5.6.5.tar.xz
d949a468af5da8b1db48a311954b06c6 kscreenlocker-5.6.5.tar.xz
cc5407dcd31778b81b929dd833deb25b oxygen-5.6.5.tar.xz
968f0dcd88e96e0e52c561e333b57f2b kinfocenter-5.6.5.tar.xz
898c3b27feb1d86d3936ea170ba65890 ksysguard-5.6.5.tar.xz
42829fd13bb42b2ec494315da1507670 kwin-5.6.5.tar.xz
084b6cd34bb961a1f96234fc6e406e48 systemsettings-5.6.5.tar.xz
#340806c1a66ac443837e77f421181c09 plasma-workspace-5.6.5.tar.xz
340806c1a66ac443837e77f421181c09 plasma-workspace-5.6.5.1.tar.xz
a8c144df8b08ad0853bcdb51642361d5 bluedevil-5.6.5.tar.xz
2cf0bf3c9e392f1f4751176ddd3fa13f kde-gtk-config-5.6.5.tar.xz
4f956210baea44254d5d5fdd8f516d4a khotkeys-5.6.5.tar.xz
304f6a029ece2b0da8ddd07fb892a0ae kmenuedit-5.6.5.tar.xz
060b56fb63ed8a493a0ab8ab60ae486d kscreen-5.6.5.tar.xz
4774f5d95199bf94806cd6b63a64e676 kwallet-pam-5.6.5.tar.xz
a72a8b5f705e6ab68f3f209ae817480a kwayland-integration-5.6.5.tar.xz
5d00f53ee1b3713a54a9f3d64095d932 kwrited-5.6.5.tar.xz
d4c33cf3856db7e3af8a2cade370e14d milou-5.6.5.tar.xz
9b9e6c59710285a603f29d01def056c8 plasma-nm-5.6.5.tar.xz
7130274b1089a12697121bdc57dde266 plasma-pa-5.6.5.tar.xz
4ad9d8fc0be4ca99800856b888023fca plasma-workspace-wallpapers-5.6.5.tar.xz
d57d8318146fae78dadec75abdf3328c polkit-kde-agent-1-5.6.5.tar.xz
d988b78411f1f370230b8854456ebe7b powerdevil-5.6.5.tar.xz
36858c6e1696bfead82d3a06edc6df20 plasma-desktop-5.6.5.tar.xz
b0cf3a7e6147d1fc33ca40895a9998fa kdeplasma-addons-5.6.5.tar.xz
37dee802109c585f5ccf94da294b022d kgamma5-5.6.5.tar.xz
4a42a147c82c56924ebdb07de72616fd ksshaskpass-5.6.5.tar.xz
133031892c4c93891ce26176ca483828 plasma-mediacenter-5.6.5.tar.xz
#ebde5a3ececfc0b34e43580e0b6e0a26 plasma-sdk-5.6.5.tar.xz
3ff070fd1c450fbbfc9a7628fed15601 sddm-kcm-5.6.5.tar.xz
3b6b859443a79ac47a04542e55f4dc52 user-manager-5.6.5.tar.xz
ce253c1c0b1f2d70db2bf9a9b0ba9381 discover-5.6.5.tar.xz
8b23b0b1af6b70e335640d779ca9fc9e breeze-grub-5.6.5.tar.xz
97beb61c443e298196c6ec86cd7533f3 breeze-plymouth-5.6.5.tar.xz
1601ae991cecb49a2fa0eda05ac056a2 kactivitymanagerd-5.6.5.tar.xz
bf34fb0e93402001f327bf99c195cebe plasma-integration-5.6.5.tar.xz
EOF


as_root()
{
  if   [ $EUID = 0 ];        then $*
  elif [ -x /usr/bin/sudo ]; then sudo $*
  else                            su -c \\"$*\\"
  fi
}
export -f as_root


while read -r line; do
    # Get the file name, ignoring comments and blank lines
    if $(echo $line | grep -E -q '^ *$|^#' ); then continue; fi
    file=$(echo $line | cut -d" " -f2)
    pkg=$(echo $file|sed 's|^.*/||')          # Remove directory
    packagedir=$(echo $pkg|sed 's|\.tar.*||') # Package directory
    # Correct the name of the extracted directory
    case $packagedir in
      plasma-workspace-5.6.5.1 )
        packagedir=plasma-workspace-5.6.5
        ;;
    esac
    tar -xf $file
    pushd $packagedir
       mkdir build
       cd    build
       cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
             -DCMAKE_BUILD_TYPE=Release         \
             -DLIB_INSTALL_DIR=lib              \
             -DBUILD_TESTING=OFF                \
             -Wno-dev ..  &&
        make "-j`nproc`"
        as_root make install
    popd
    as_root rm -rf $packagedir
    as_root /sbin/ldconfig
done < plasma-5.6.5.md5

cd $KF5_PREFIX/share/plasma/plasmoids
for j in $(find -name \*.js); do
  as_root ln -sfv ../code/$(basename $j) $(dirname $j)/../ui/
done


cd $SOURCE_DIR

echo "plasma-all=>`date`" | sudo tee -a $INSTALLED_LIST

