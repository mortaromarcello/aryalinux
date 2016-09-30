#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:jtreg-4.2-b03:639
#VER:jdk8u102-b:14
#VER:icedtea-web:1.6.2

#REQ:java
#REQ:ojdk-conf
#REQ:alsa-lib
#REQ:cpio
#REQ:cups
#REQ:unzip
#REQ:general_which
#REQ:x7lib
#REQ:zip
#REC:cacerts
#REC:giflib
#REC:wget
#OPT:mercurial
#OPT:twm


cd $SOURCE_DIR

URL=http://hg.openjdk.java.net/jdk8u/jdk8u/archive/jdk8u102-b14.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icedtea/icedtea-web-1.6.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icedtea/icedtea-web-1.6.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icedtea/icedtea-web-1.6.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icedtea/icedtea-web-1.6.2.tar.gz || wget -nc http://icedtea.classpath.org/download/source/icedtea-web-1.6.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icedtea/icedtea-web-1.6.2.tar.gz
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/jdk/jdk8u102-b14.tar.bz2 || wget -nc http://hg.openjdk.java.net/jdk8u/jdk8u/archive/jdk8u102-b14.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/jdk/jdk8u102-b14.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/jdk/jdk8u102-b14.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/jdk/jdk8u102-b14.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/jdk/jdk8u102-b14.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/jtreg-4.2-b03-639.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/jtreg-4.2-b03-639.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openjdk/jtreg-4.2-b03-639.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openjdk/jtreg-4.2-b03-639.tar.gz || wget -nc http://anduin.linuxfromscratch.org/BLFS/OpenJDK/OpenJDK-1.8.0.102/jtreg-4.2-b03-639.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjdk/jtreg-4.2-b03-639.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

cat > subprojects.md5 << EOF &&
6ea4a074a80d0ee4b6dcd50398835c49  corba.tar.bz2
27b9e7e94fc6a47f452e8a94ba156395  hotspot.tar.bz2
da82a91df3eb4c98ebaab4e71cbbcc4d  jaxp.tar.bz2
8a91561bbc04f50a92032d82b78960e0  jaxws.tar.bz2
61c645dbacfb925944f716ec50474821  langtools.tar.bz2
e65f6d029808a8b523e07d818c8ac9ad  jdk.tar.bz2
2c981235c1cbaba58197fd9b7ffd00e1  nashorn.tar.bz2
EOF
for subproject in corba hotspot jaxp jaxws langtools jdk nashorn; do
  wget -c http://hg.openjdk.java.net/jdk8u/jdk8u/${subproject}/archive/jdk8u102-b14.tar.bz2 \
       -O ${subproject}.tar.bz2
done &&
md5sum -c subprojects.md5 &&
for subproject in corba hotspot jaxp jaxws langtools jdk nashorn; do
  mkdir -pv ${subproject} &&
  tar -xf ${subproject}.tar.bz2 --strip-components=1 -C ${subproject}
done


tar -xf ../jtreg-4.2-b03-639.tar.gz


unset JAVA_HOME               &&
sh ./configure                \
   --with-update-version=102   \
   --with-build-number=b14    \
   --with-milestone=BLFS      \
   --enable-unlimited-crypto  \
   --with-zlib=system         \
   --with-giflib=system       \
   --with-extra-cflags="-std=c++98 -Wno-error -fno-delete-null-pointer-checks -fno-lifetime-dse" \
   --with-extra-cxxflags="-std=c++98 -fno-delete-null-pointer-checks -fno-lifetime-dse" &&
make DEBUG_BINARIES=true SCTP_WERROR= all  &&
find build/*/images/j2sdk-image -iname \*.diz -delete


if [ -n "$DISPLAY" ]; then
  OLD_DISP=$DISPLAY
fi
export DISPLAY=:20
nohup Xvfb $DISPLAY                              \
           -fbdir $(pwd)                         \
           -pixdepths 8 16 24 32 > Xvfb.out 2>&1 &
echo $! > Xvfb.pid
echo Waiting for Xvfb to initialize; sleep 1
nohup twm -display $DISPLAY \
          -f /dev/null > twm.out 2>&1            &
echo $! > twm.pid
echo Waiting for twm to initialize; sleep 1
xhost +


echo -e "
jdk_all = :jdk_core           \\
          :jdk_svc            \\
          :jdk_beans          \\
          :jdk_imageio        \\
          :jdk_sound          \\
          :jdk_sctp           \\
          com/sun/awt         \\
          javax/accessibility \\
          javax/print         \\
          sun/pisces          \\
          com/sun/java/swing" >> jdk/test/TEST.groups &&
sed -e 's/all:.*jck.*/all: jtreg/'      \
    -e '/^JTREG /s@\$(JT_PLATFORM)/@@'  \
    -i langtools/test/Makefile


JT_JAVA=$(type -p javac | sed 's@/bin.*@@') &&
JT_HOME=$(pwd)/jtreg                        &&
PRODUCT_HOME=$(echo $(pwd)/build/*/images/j2sdk-image)


LANG=C make -k -C test                      \
            JT_HOME=${JT_HOME}              \
            JT_JAVA=${JT_JAVA}              \
            PRODUCT_HOME=${PRODUCT_HOME} all
LANG=C ${JT_HOME}/bin/jtreg -a -v:fail,error \
                -dir:$(pwd)/hotspot/test     \
                -k:\!ignore                  \
                -jdk:${PRODUCT_HOME}         \
                :jdk


kill -9 `cat twm.pid`  &&
kill -9 `cat Xvfb.pid` &&
rm -f Xvfb.out twm.out &&
rm -f Xvfb.pid twm.pid &&
if [ -n "$OLD_DISP" ]; then
  DISPLAY=$OLD_DISP
fi



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -RT build/*/images/j2sdk-image /opt/OpenJDK-1.8.0.102 &&
chown -R root:root /opt/OpenJDK-1.8.0.102

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -v -nsf OpenJDK-1.8.0.102 /opt/jdk

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


tar -xf ../icedtea-web-1.6.2.tar.gz  \
        icedtea-web-1.6.2/javaws.png \
        --strip-components=1



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir -pv /usr/share/applications &&
cat > /usr/share/applications/openjdk-8-policytool.desktop << "EOF" &&
[Desktop Entry]
Name=OpenJDK Java Policy Tool
Name[pt_BR]=OpenJDK Java - Ferramenta de Pol�tica
Comment=OpenJDK Java Policy Tool
Comment[pt_BR]=OpenJDK Java - Ferramenta de Pol�tica
Exec=/opt/jdk/bin/policytool
Terminal=false
Type=Application
Icon=javaws
Categories=Settings;
EOF
install -v -Dm0644 javaws.png /usr/share/pixmaps/javaws.png

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /opt/jdk/bin/mkcacerts << "EOF"
#!/bin/sh
# Simple script to extract x509 certificates and create a JRE cacerts file.
function get_args()
 {
 if test -z "${1}" ; then
 showhelp
 exit 1
 fi
 while test -n "${1}" ; do
 case "${1}" in
 -f | --cafile)
 check_arg $1 $2
 CAFILE="${2}"
 shift 2
 ;;
 -d | --cadir)
 check_arg $1 $2
 CADIR="${2}"
 shift 2
 ;;
 -o | --outfile)
 check_arg $1 $2
 OUTFILE="${2}"
 shift 2
 ;;
 -k | --keytool)
 check_arg $1 $2
 KEYTOOL="${2}"
 shift 2
 ;;
 -s | --openssl)
 check_arg $1 $2
 OPENSSL="${2}"
 shift 2
 ;;
 -h | --help)
 showhelp
 exit 0
 ;;
 *)
 showhelp
 exit 1
 ;;
 esac
 done
 }
function check_arg()
 {
 echo "${2}" | grep -v "^-" > /dev/null
 if [ -z "$?" -o ! -n "$2" ]; then
 echo "Error: $1 requires a valid argument."
 exit 1
 fi
 }
# The date binary is not reliable on 32bit systems for dates after 2038
function mydate()
 {
 local y=$( echo $1 | cut -d" " -f4 )
 local M=$( echo $1 | cut -d" " -f1 )
 local d=$( echo $1 | cut -d" " -f2 )
 local m
 if [ ${d} -lt 10 ]; then d="0${d}"; fi
 case $M in
 Jan) m="01";;
 Feb) m="02";;
 Mar) m="03";;
 Apr) m="04";;
 May) m="05";;
 Jun) m="06";;
 Jul) m="07";;
 Aug) m="08";;
 Sep) m="09";;
 Oct) m="10";;
 Nov) m="11";;
 Dec) m="12";;
 esac
 certdate="${y}${m}${d}"
 }
function showhelp()
 {
 echo "`basename ${0}` creates a valid cacerts file for use with IcedTea."
 echo ""
 echo " -f --cafile The path to a file containing PEM"
 echo " formated CA certificates. May not be"
 echo " used with -d/--cadir."
 echo ""
 echo " -d --cadir The path to a directory of PEM formatted"
 echo " CA certificates. May not be used with"
 echo " -f/--cafile."
 echo ""
 echo " -o --outfile The path to the output file."
 echo ""
 echo " -k --keytool The path to the java keytool utility."
 echo ""
 echo " -s --openssl The path to the openssl utility."
 echo ""
 echo " -h --help Show this help message and exit."
 echo ""
 echo ""
 }
# Initialize empty variables so that the shell does not pollute the script
CAFILE=""
CADIR=""
OUTFILE=""
OPENSSL=""
KEYTOOL=""
certdate=""
date=""
today=$( date +%Y%m%d )
# Process command line arguments
get_args ${@}
# Handle common errors
if test "${CAFILE}x" == "x" -a "${CADIR}x" == "x" ; then
 echo "ERROR! You must provide an x509 certificate store!"
 echo "\'$(basename ${0}) --help\' for more info."
 echo ""
 exit 1
fi
if test "${CAFILE}x" != "x" -a "${CADIR}x" != "x" ; then
 echo "ERROR! You cannot provide two x509 certificate stores!"
 echo "\'$(basename ${0}) --help\' for more info."
 echo ""
 exit 1
fi
if test "${KEYTOOL}x" == "x" ; then
 echo "ERROR! You must provide a valid keytool program!"
 echo "\'$(basename ${0}) --help\' for more info."
 echo ""
 exit 1
fi
if test "${OPENSSL}x" == "x" ; then
 echo "ERROR! You must provide a valid path to openssl!"
 echo "\'$(basename ${0}) --help\' for more info."
 echo ""
 exit 1
fi
if test "${OUTFILE}x" == "x" ; then
 echo "ERROR! You must provide a valid output file!"
 echo "\'$(basename ${0}) --help\' for more info."
 echo ""
 exit 1
fi
# Get on with the work
# If using a CAFILE, split it into individual files in a temp directory
if test "${CAFILE}x" != "x" ; then
 TEMPDIR=`mktemp -d`
 CADIR="${TEMPDIR}"
 # Get a list of staring lines for each cert
 CERTLIST=`grep -n "^-----BEGIN" "${CAFILE}" | cut -d ":" -f 1`
 # Get a list of ending lines for each cert
 ENDCERTLIST=`grep -n "^-----END" "${CAFILE}" | cut -d ":" -f 1`
 # Start a loop
 for certbegin in `echo "${CERTLIST}"` ; do
 for certend in `echo "${ENDCERTLIST}"` ; do
 if test "${certend}" -gt "${certbegin}"; then
 break
 fi
 done
 sed -n "${certbegin},${certend}p" "${CAFILE}" > "${CADIR}/${certbegin}.pem"
 keyhash=`${OPENSSL} x509 -noout -in "${CADIR}/${certbegin}.pem" -hash`
 echo "Generated PEM file with hash: ${keyhash}."
 done
fi
# Write the output file
for cert in `find "${CADIR}" -type f -name "*.pem" -o -name "*.crt"`
do
 # Make sure the certificate date is valid...
 date=$( ${OPENSSL} x509 -enddate -in "${cert}" -noout | sed 's/^notAfter=//' )
 mydate "${date}"
 if test "${certdate}" -lt "${today}" ; then
 echo "${cert} expired on ${certdate}! Skipping..."
 unset date certdate
 continue
 fi
 unset date certdate
 ls "${cert}"
 tempfile=`mktemp`
 certbegin=`grep -n "^-----BEGIN" "${cert}" | cut -d ":" -f 1`
 certend=`grep -n "^-----END" "${cert}" | cut -d ":" -f 1`
 sed -n "${certbegin},${certend}p" "${cert}" > "${tempfile}"
 echo yes | env LC_ALL=C "${KEYTOOL}" -import \
 -alias `basename "${cert}"` \
 -keystore "${OUTFILE}" \
 -storepass 'changeit' \
 -file "${tempfile}"
 rm "${tempfile}"
done
if test "${TEMPDIR}x" != "x" ; then
 rm -rf "${TEMPDIR}"
fi
exit 0
EOF
chmod -c 0755 /opt/jdk/bin/mkcacerts

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if [ -f /opt/jdk/jre/lib/security/cacerts ]; then
  mv /opt/jdk/jre/lib/security/cacerts \
     /opt/jdk/jre/lib/security/cacerts.bak
fi &&
/opt/jdk/bin/mkcacerts                 \
        -d "/etc/ssl/certs/"           \
        -k "/opt/jdk/bin/keytool"      \
        -s "/usr/bin/openssl"          \
        -o "/opt/jdk/jre/lib/security/cacerts"

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cd /opt/jdk
bin/keytool -list -keystore jre/lib/security/cacerts

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "openjdk=>`date`" | sudo tee -a $INSTALLED_LIST

