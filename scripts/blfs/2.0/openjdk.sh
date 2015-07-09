#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:java
#DEP:alsa-lib
#DEP:cpio
#DEP:cups
#DEP:unzip
#DEP:which
#DEP:x7lib
#DEP:zip
#DEP:cacerts
#DEP:giflib


cd $SOURCE_DIR






tar -xf ../corba.tar.xz      &&
tar -xf ../hotspot.tar.xz    &&
tar -xf ../jaxp.tar.xz       &&
tar -xf ../jaxws.tar.xz      &&
tar -xf ../jdk.tar.xz        &&
tar -xf ../langtools.tar.xz  &&
tar -xf ../nashorn.tar.xz

tar -xf ../jtreg4.1-b10.tar.gz

sed -e 's/DGifCloseFile(gif/&, NULL/' \
    -e '/DGifOpen/s/c)/c, NULL)/'     \
    -i jdk/src/share/native/sun/awt/splashscreen/splashscreen_gif.c

sed 's/\([ \t]\)\]\([^\]\)/\1I]\2/g' \
    -i hotspot/make/linux/makefiles/adjust-mflags.sh

unset JAVA_HOME               &&
sh ./configure                \
   --with-update-version=31   \
   --with-build-number=b13    \
   --with-milestone=BLFS      \
   --enable-unlimited-crypto  \
   --with-zlib=system         \
   --with-giflib=system       &&
make DEBUG_BINARIES=true all

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
sed -e 's/all:.*jck.*/all: jtreg/' \
    -i langtools/test/Makefile

JT_JAVA=$(type -p javac | sed 's@/bin.*@@') &&
JT_HOME=$(pwd)/jtreg                        &&
PRODUCT_HOME=$(echo $(pwd)/build/*/images/j2sdk-image)

LANG=C make -k -C test                      \
            JT_HOME=${JT_HOME}              \
            JT_JAVA=${JT_JAVA}              \
            PRODUCT_HOME=${PRODUCT_HOME} all
LANG=C ${JT_HOME}/linux/bin/jtreg -a -v:fail,error \
                -dir:$(pwd)/hotspot/test    \
                -k:\!ignore                 \
                -jdk:${PRODUCT_HOME}        \
                :jdk

kill -9 `cat twm.pid`  &&
kill -9 `cat Xvfb.pid` &&
rm -f Xvfb.out twm.out &&
rm -f Xvfb.pid twm.pid &&
if [ -n "$OLD_DISP" ]; then
  DISPLAY=$OLD_DISP
fi

cat > 1434987998780.sh << "ENDOFFILE"
find build/*/images/j2sdk-image -iname \*.jar -exec chmod a+r {} \; &&
chmod a+r build/*/images/j2sdk-image/lib/ct.sym &&
find build/*/images/j2sdk-image -iname \*.diz -delete &&
find build/*/images/j2sdk-image -iname \*.debuginfo -delete &&
cp -R build/*/images/j2sdk-image /opt/OpenJDK-1.8.0.31 &&
chown -R root:root /opt/OpenJDK-1.8.0.31
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh

tar -xf ../icedtea-web-1.5.2.tar.gz  \
        icedtea-web-1.5.2/javaws.png \
        --strip-components=1

cat > 1434987998780.sh << "ENDOFFILE"
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

install -v -Dm644 javaws.png /usr/share/pixmaps/javaws.png
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh

cat > 1434987998780.sh << "ENDOFFILE"
ln -sfv OpenJDK-1.8.0.31-bin /opt/jdk
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh

cat > 1434987998780.sh << "ENDOFFILE"
cat > /etc/profile.d/openjdk.sh << "EOF"
# Begin /etc/profile.d/openjdk.sh

# Set JAVA_HOME directory
JAVA_HOME=/opt/jdk

# Set ANT_HOME directory
ANT_HOME=/opt/ant

# Adjust PATH
pathappend $JAVA_HOME/bin PATH
pathappend $ANT_HOME/bin PATH

pathappend $JAVA_HOME/include C_INCLUDE_PATH
pathappend $JAVA_HOME/include/linux C_INCLUDE_PATH
pathappend $JAVA_HOME/include CPLUS_INCLUDE_PATH
pathappend $JAVA_HOME/include/linux CPLUS_INCLUDE_PATH

# Auto Java CLASSPATH
# Copy jar files to, or create symlinks in this directory

AUTO_CLASSPATH_DIR=/usr/share/java

pathprepend . CLASSPATH

for dir in `find ${AUTO_CLASSPATH_DIR} -type d 2>/dev/null`; do
 pathappend $dir CLASSPATH
done

for jar in `find ${AUTO_CLASSPATH_DIR} -name "*.jar" 2>/dev/null`; do
 pathappend $jar CLASSPATH
done

export JAVA_HOME ANT_HOME CLASSPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
unset AUTO_CLASSPATH_DIR dir jar

# End /etc/profile.d/openjdk.sh
EOF
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh

cat > 1434987998780.sh << "ENDOFFILE"
cat >> /etc/profile.d/extrapaths.sh << "EOF" &&
# Begin Java addition
pathappend /opt/jdk/man MANPATH
# End Java addition
EOF


cat >> /etc/man_db.conf << "EOF" &&
# Begin Java addition
MANDATORY_MANPATH /opt/jdk/man
MANPATH_MAP /opt/jdk/bin /opt/jdk/man
MANDB_MAP /opt/jdk/man /var/cache/man/jdk
# End Java addition
EOF

mkdir -p /var/cache/man
mandb -c /opt/jdk/man
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh

cat > 1434987998780.sh << "ENDOFFILE"
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

chmod -v 755 /opt/jdk/bin/mkcacerts
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh

cat > 1434987998780.sh << "ENDOFFILE"
/opt/jdk/bin/mkcacerts            \
        -d "/etc/ssl/certs/"      \
        -k "/opt/jdk/bin/keytool" \
        -s "/usr/bin/openssl"     \
        -o "/opt/jdk/jre/lib/security/cacerts"
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh

cat > 1434987998780.sh << "ENDOFFILE"
cd /opt/jdk
bin/keytool -list -keystore jre/lib/security/cacerts
ENDOFFILE
chmod a+x 1434987998780.sh
sudo ./1434987998780.sh
sudo rm -rf 1434987998780.sh


 
cd $SOURCE_DIR
 
echo "openjdk=>`date`" | sudo tee -a $INSTALLED_LIST