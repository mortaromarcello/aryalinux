#!/bin/bash

#############################################################################
## Name:                                                                   ##
## Version:                                                                ##
## Packager: Mortaro Marcello (mortaromarcello@gmail.com)                  ##
## Homepage:                                                               ##
#############################################################################
set -e
set +h

SOURCE_ONLY=n
DESCRIPTION="\n CA Certificate Download: <a class=\"ulink\" href=\"http://anduin.linuxfromscratch.org/BLFS/other/certdata.txt\">http://anduin.linuxfromscratch.org/BLFS/other/certdata.txt</a>\n"
SECTION="postlfs"
VERSION=0.1
NAME="cacerts"
PKGNAME=$NAME
REVISION=1

#REQ:openssl
#REC:wget

ARCH=`uname -m`

START=`pwd`
PKG=$START/pkg
SRC=$START/work

function unzip_file()
{
	dir_name=$(unzip_dirname $1 $2)
	echo $dir_name
	if [ `echo $dir_name | grep "extracted$"` ]
	then
		echo "Create and extract..."
		mkdir $dir_name
		cp $1 $dir_name
		cd $dir_name
		unzip $1
		cd ..
	else
		echo "Just Extract..."
		unzip $1
	fi
}
function build() {
    mkdir -vp $PKG $SRC
    cd $SRC
    URL=
    if [ ! -z $URL ]; then
        wget 
        TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
        if [ -z $(echo $TARBALL | grep ".zip$") ]; then
            DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
            tar --no-overwrite-dir -xvf $TARBALL
        else
            DIRECTORY=$(unzip_dirname $TARBALL $NAME)
            unzip_file $TARBALL $NAME
        fi
        cd $DIRECTORY
    fi
    mkdir -vp $PKG/usr/bin
    cat > $PKG/usr/bin/make-cert.pl << "EOF"
#!/usr/bin/perl -w
# Used to generate PEM encoded files from Mozilla certdata.txt.
# Run as ./make-cert.pl > certificate.crt
#
# Parts of this script courtesy of RedHat (mkcabundle.pl)
#
# This script modified for use with single file data (tempfile.cer) extracted
# from certdata.txt, taken from the latest version in the Mozilla NSS source.
# mozilla/security/nss/lib/ckfw/builtins/certdata.txt
#
# Authors: DJ Lucas
# Bruce Dubbs
#
# Version 20120211
my $certdata = './tempfile.cer';
open( IN, "cat $certdata|" )
 || die "could not open $certdata";
my $incert = 0;
while ( <IN> )
{
 if ( /^CKA_VALUE MULTILINE_OCTAL/ )
 {
 $incert = 1;
 open( OUT, "|openssl x509 -text -inform DER -fingerprint" )
 || die "could not pipe to openssl x509";
 }
 elsif ( /^END/ && $incert )
 {
 close( OUT );
 $incert = 0;
 print "\n\n";
 }
 elsif ($incert)
 {
 my @bs = split( /\\/ );
 foreach my $b (@bs)
 {
 chomp $b;
 printf( OUT "%c", oct($b) ) unless $b eq '';
 }
 }
}
EOF
    chmod +x $PKG/usr/bin/make-cert.pl
    cat > $PKG/usr/bin/make-ca.sh << "EOF"
#!/bin/sh
# Begin make-ca.sh
# Script to populate OpenSSL's CApath from a bundle of PEM formatted CAs
#
# The file certdata.txt must exist in the local directory
# Version number is obtained from the version of the data.
#
# Authors: DJ Lucas
# Bruce Dubbs
#
# Version 20120211
# Some data in the certs have UTF-8 characters
export LANG=en_US.utf8
certdata="certdata.txt"
if [ ! -r $certdata ]; then
 echo "$certdata must be in the local directory"
 exit 1
fi
REVISION=$(grep CVS_ID $certdata | cut -f4 -d'$')
if [ -z "${REVISION}" ]; then
 echo "$certfile has no 'Revision' in CVS_ID"
 exit 1
fi
VERSION=$(echo $REVISION | cut -f2 -d" ")
TEMPDIR=$(mktemp -d)
TRUSTATTRIBUTES="CKA_TRUST_SERVER_AUTH"
BUNDLE="BLFS-ca-bundle-${VERSION}.crt"
CONVERTSCRIPT="/usr/bin/make-cert.pl"
SSLDIR="/etc/ssl"
mkdir "${TEMPDIR}/certs"
# Get a list of starting lines for each cert
CERTBEGINLIST=$(grep -n "^# Certificate" "${certdata}" | cut -d ":" -f1)
# Get a list of ending lines for each cert
CERTENDLIST=`grep -n "^CKA_TRUST_STEP_UP_APPROVED" "${certdata}" | cut -d ":" -f 1`
# Start a loop
for certbegin in ${CERTBEGINLIST}; do
 for certend in ${CERTENDLIST}; do
 if test "${certend}" -gt "${certbegin}"; then
 break
 fi
 done
 # Dump to a temp file with the name of the file as the beginning line number
 sed -n "${certbegin},${certend}p" "${certdata}" > "${TEMPDIR}/certs/${certbegin}.tmp"
done
unset CERTBEGINLIST CERTDATA CERTENDLIST certbegin certend
mkdir -p certs
rm -f certs/* # Make sure the directory is clean
for tempfile in ${TEMPDIR}/certs/*.tmp; do
 # Make sure that the cert is trusted...
 grep "CKA_TRUST_SERVER_AUTH" "${tempfile}" | \
 egrep "TRUST_UNKNOWN|NOT_TRUSTED" > /dev/null
 if test "${?}" = "0"; then
 # Throw a meaningful error and remove the file
 cp "${tempfile}" tempfile.cer
 perl ${CONVERTSCRIPT} > tempfile.crt
 keyhash=$(openssl x509 -noout -in tempfile.crt -hash)
 echo "Certificate ${keyhash} is not trusted! Removing..."
 rm -f tempfile.cer tempfile.crt "${tempfile}"
 continue
 fi
 # If execution made it to here in the loop, the temp cert is trusted
 # Find the cert data and generate a cert file for it
 cp "${tempfile}" tempfile.cer
 perl ${CONVERTSCRIPT} > tempfile.crt
 keyhash=$(openssl x509 -noout -in tempfile.crt -hash)
 mv tempfile.crt "certs/${keyhash}.pem"
 rm -f tempfile.cer "${tempfile}"
 echo "Created ${keyhash}.pem"
done
# Remove blacklisted files
# MD5 Collision Proof of Concept CA
if test -f certs/8f111d69.pem; then
 echo "Certificate 8f111d69 is not trusted! Removing..."
 rm -f certs/8f111d69.pem
fi
# Finally, generate the bundle and clean up.
cat certs/*.pem > ${BUNDLE}
rm -r "${TEMPDIR}"
EOF
    chmod +x $PKG/usr/bin/make-ca.sh
    mkdir -vp $PKG/usr/sbin
    cat > $PKG/usr/sbin/remove-expired-certs.sh << "EOF"
#!/bin/sh
# Begin /usr/sbin/remove-expired-certs.sh
#
# Version 20120211
# Make sure the date is parsed correctly on all systems
mydate()
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
OPENSSL=/usr/bin/openssl
DIR=/etc/ssl/certs
if [ $# -gt 0 ]; then
 DIR="$1"
fi
certs=$( find ${DIR} -type f -name "*.pem" -o -name "*.crt" )
today=$( date +%Y%m%d )
for cert in $certs; do
 notafter=$( $OPENSSL x509 -enddate -in "${cert}" -noout )
 date=$( echo ${notafter} | sed 's/^notAfter=//' )
 mydate "$date"
 if [ ${certdate} -lt ${today} ]; then
 echo "${cert} expired on ${certdate}! Removing..."
 rm -f "${cert}"
 fi
done
EOF
    chmod u+x $PKG/usr/sbin/remove-expired-certs.sh
}

function package() {
    cd $PKG
    find . -type f -name "*"|sed 's/^.//' > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    find . -type d -name "*"|sed 's/^.//' >> $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files
    gzip -f $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz
    mkdir -vp $PKG/install
    mv -v $START/$PKGNAME-$VERSION-$ARCH-$REVISION.files.gz $PKG/install/
    echo -e $DESCRIPTION > $PKG/install/blfs-desc
    cat > $PKG/install/doinst.sh << "EOF"
mkdir -vp /tmp/cacerts && cd /tmp/cacerts
URL=http://anduin.linuxfromscratch.org/BLFS/other/certdata.txt &&
wget -nc $URL                                                  &&
make-ca.sh                                                     &&
unset URL
SSLDIR=/etc/ssl                                              &&
remove-expired-certs.sh certs                                &&
install -d ${SSLDIR}/certs                                   &&
cp -v certs/*.pem ${SSLDIR}/certs                            &&
c_rehash                                                     &&
install BLFS-ca-bundle*.crt ${SSLDIR}/ca-bundle.crt          &&
ln -sfv ../ca-bundle.crt ${SSLDIR}/certs/ca-certificates.crt &&
unset SSLDIR
rm -r certs BLFS-ca-bundle*
EOF
    tar cvvf - . --format gnu --xform 'sx^\./\(.\)x\1x' --show-stored-names --group 0 --owner 0 | gzip > $START/$PKGNAME-$VERSION-$ARCH-$REVISION.tgz
    echo "blfs package \"$PKGNAME-$VERSION-$ARCH-$REVISION.tgz\" created."
}

build
package

if [ ! -z $URL ]; then
    cd $START && rm -vrf $PKG && rm -vrf $SRC
fi
