#!/bin/bash

FILENAME="$1.sh"
URL="$2"

cat > $FILENAME <<EOF
#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

EOF

cat >> $FILENAME <<"EOF"
cd $SOURCE_DIR
EOF

cat >> $FILENAME <<EOF

URL="$URL"
EOF

cat >> $FILENAME <<"EOF"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

EOF

cat >> $FILENAME <<EOF
echo "$1=>PRESENT_DATE" | sudo tee -a $INSTALLED_LIST
EOF

sed -i "s@sudo tee -a @sudo tee -a \$INSTALLED_LIST@g" $FILENAME
sed -i "s@PRESENT_DATE@\`date\`@g" $FILENAME

chmod 755 $FILENAME
