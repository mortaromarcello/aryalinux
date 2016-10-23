#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Chromium is an open-source browserbr3ak project that aims to build a safer, faster, and more stable way forbr3ak all users to experience the web.br3ak
#SECTION:xsoft

whoami > /tmp/currentuser

#REQ:alsa-lib
#REQ:cups
#REQ:desktop-file-utils
#REQ:dbus
#REQ:perl-modules#perl-file-basedir
#REQ:gtk2
#REQ:hicolor-icon-theme
#REQ:mitkrb
#REQ:mesa
#REQ:ninja
#REQ:nss
#REQ:python2
#REQ:usbutils
#REQ:xorg-server
#REC:flac
#REC:GConf
#REC:gnome-keyring
#REC:hicolor-icon-theme
#REC:libevent
#REC:libexif
#REC:libjpeg
#REC:libpng
#REC:libsecret
#REC:pciutils
#REC:pulseaudio
#REC:xdg-utils
#REC:yasm
#OPT:ffmpeg
#OPT:git
#OPT:icu
#OPT:libxml2
#OPT:libvpx


#VER:chromium:53.0.2785.143
#VER:v:3


NAME="chromium"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/chromium/chromium-53.0.2785.143.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/chromium/chromium-53.0.2785.143.tar.xz || wget -nc https://commondatastorage.googleapis.com/chromium-browser-official/chromium-53.0.2785.143.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/chromium/chromium-53.0.2785.143.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/chromium/chromium-53.0.2785.143.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/chromium/chromium-53.0.2785.143.tar.xz
wget -nc https://github.com/foutrelis/chromium-launcher/archive/v3.tar.gz


URL=https://commondatastorage.googleapis.com/chromium-browser-official/chromium-53.0.2785.143.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

wget https://github.com/foutrelis/chromium-launcher/archive/v3.tar.gz \
     -O chromium-launcher-3.tar.gz


python build/download_nacl_toolchains.py --packages \
    nacl_x86_newlib,pnacl_newlib,pnacl_translator \
    sync --extract


sed "s/WIDEVINE_CDM_AVAILABLE/&\n\n#define WIDEVINE_CDM_VERSION_STRING \"Pinkie Pie\"/" \
    -i third_party/widevine/cdm/stub/widevine_cdm_version.h


CHROMIUM_CONFIG=(
-Dgoogle_api_key=AIzaSyDxKL42zsPjbke5O8_rPVpVrLrJ8aeE9rQ
-Dgoogle_default_client_id=595013732528-llk8trb03f0ldpqq6nprjp1s79596646.apps.googleusercontent.com
-Dgoogle_default_client_secret=5ntt6GbbkjnTVXx-MSxbmx5e
-Dwerror=
-Dclang=0
-Dpython_ver=2.7
-Dlinux_link_gsettings=1
-Dlinux_link_libpci=1
-Dlinux_link_pulseaudio=1
-Dlinux_strip_binary=1
-Dlinux_use_bundled_binutils=0
-Dlinux_use_bundled_gold=0
-Dlinux_use_gold_flags=0
-Dicu_use_data_file_flag=1
-Dlogging_like_official_build=1
-Dtracing_like_official_build=1
-Dfieldtrial_testing_like_official_build=1
-Drelease_extra_cflags="$CFLAGS"
-Dffmpeg_branding=Chrome
-Dproprietary_codecs=1
-Duse_gnome_keyring=0
-Duse_system_bzip2=1
-Duse_system_flac=1
-Duse_system_ffmpeg=0
-Duse_system_harfbuzz=1
-Duse_system_icu=0
-Duse_system_libevent=1
-Duse_system_libjpeg=1
-Duse_system_libpng=1
-Duse_system_libvpx=0
-Duse_system_libxml=0
-Duse_system_snappy=0
-Duse_system_xdg_utils=1
-Duse_system_yasm=1
-Duse_system_zlib=0
-Dusb_ids_path=/usr/share/hwdata/usb.ids
-Duse_mojo=0
-Duse_gconf=1
-Duse_sysroot=0
-Denable_hangout_services_extension=1
-Denable_widevine=1
-Ddisable_fatal_linker_warnings=1
-Ddisable_glibc=1)


export CFLAGS+=' -fno-delete-null-pointer-checks'


sed 's/#include <cups\/cups\.h>/&\n#include <cups\/ppd.h>/' \
    -i printing/backend/cups_helper.h


sed 's/#include \<sys\/mman\.h>/&\n\n#if defined(MADV_FREE)\n#undef MADV_FREE\n#endif\n/' \
    -i.bak third_party/WebKit/Source/wtf/allocator/PageAllocator.cpp


build/linux/unbundle/replace_gyp_files.py "${CHROMIUM_CONFIG[@]}" &&
build/gyp_chromium --depth=. "${CHROMIUM_CONFIG[@]}"


ninja -C out/Release chrome chrome_sandbox chromedriver



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vDm755  out/Release/chrome \
                 /usr/lib/chromium/chromium              &&
install -vDm4755 out/Release/chrome_sandbox \
                 /usr/lib/chromium/chrome-sandbox        &&
install -vDm755  out/Release/chromedriver \
                 /usr/lib/chromium/chromedriver          &&
ln -svf /usr/lib/chromium/chromium /usr/bin              &&
ln -svf /usr/lib/chromium/chromedriver /usr/bin/         &&
install -vDm644 out/Release/icudtl.dat /usr/lib/chromium &&
install -vm644 out/Release/{*.pak,*.bin} \
               /usr/lib/chromium/                        &&
cp -av out/Release/locales /usr/lib/chromium/            &&
chown -Rv root:root /usr/lib/chromium/locales            &&
install -vDm644 out/Release/chrome.1 \
                /usr/share/man/man1/chromium.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


for size in 16 32; do
    install -vDm644 \
        "chrome/app/theme/default_100_percent/chromium/product_logo_$size.png" \
        "/usr/share/icons/hicolor/${size}x${size}/apps/chromium.png"
done &&
for size in 22 24 48 64 128 256; do
    install -vDm644 "chrome/app/theme/chromium/product_logo_$size.png" \
        "/usr/share/icons/hicolor/${size}x${size}/apps/chromium.png"
done &&
cat > /usr/share/applications/chromium.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=Chromium Web Browser
Comment=Access the Internet
GenericName=Web Browser
Exec=chromium %u
Terminal=false
Type=Application
Icon=chromium
Categories=GTK;Network;WebBrowser;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
EOF


install -vm755 out/Release/nacl_helper{,_bootstrap} \
              out/Release/nacl_irt_*.nexe \
              /usr/lib/chromium/


install -vm755 out/Release/libwidevinecdmadapter.so \
               /usr/lib/chromium/


tar -xf ../chromium-launcher-3.tar.gz &&
cd chromium-launcher-3 &&
make PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm -f /usr/bin/chromium        &&
make PREFIX=/usr install-strip &&
cd ..

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


mkdir temp                                  &&
cd temp                                     &&
ar -x ../../google-chrome-stable_53.0.2785.143*.deb &&
tar -xf data.tar.xz



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vdm755 /usr/lib/PepperFlash &&
install -vm755 opt/google/chrome/PepperFlash/* /usr/lib/PepperFlash

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -vm755 opt/google/chrome/libwidevinecdm.so /usr/lib/chromium/

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST