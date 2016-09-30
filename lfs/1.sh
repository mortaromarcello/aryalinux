#!/bin/bash

set -e

(
 if [ ! -f /tmp/updated ]
 then
  echo "Would now go online and check for updated scripts. If you are not connected to the internet, please connect(See network Icon on upper right corner) and then press enter to continue..."
  read RESPONSE
  echo "Fetching updates on the build scripts..."
  rm -rf /tmp/2016.08.zip
  rm -rf /tmp/aryalinux-2016.08
  wget https://github.com/FluidIdeas/aryalinux/archive/2016.08.zip -O /tmp/2016.08.zip
  pushd /tmp &> /dev/null
  unzip 2016.08.zip &> /dev/null
  cp -rf aryalinux-2016.08/lfs/* /root/scripts/
  popd &> /dev/null
  clear
  echo "Updated the build scripts successfully."
  echo "Checking sanity of the tarballs. In case some tarballs are missing they would be downloaded now. Please be patient."
  ./download-sources.sh &> /dev/null
  ./additional-downloads.sh &> /dev/null
  touch /tmp/updated
  echo "Done with downloading the updated scripts. These are the languages in which build scripts are available right now. Select one of these languages:"
  echo ""
  ls | sed "s@1.sh@@g"
  echo ""
  read -p "Select language : " LANG
  cd $LANG
  ./1.sh
  exit
 fi
) || (
 echo "2."
 echo "Could not download the latest build scripts. Maybe you're not connected to the internet. You can either continue without the latest scripts or exit, connect to the internet and restart this script once connected so that I can download the updates."
 read -p "Do you want to continue without the updates? (y/n) : " RESPONSE
 if [ "x$RESPONSE" == "xn" ] || [ "x$RESPONSE" == "xN" ]
 then
  exit
 else
  echo "These are the languages in which build scripts are available right now. Select one of these languages:"
  echo ""
  ls | sed "s@1.sh@@g"
  echo ""
  read -p "Select language : " LANG
  cd $LANG
  ./1.sh
  exit
 fi
)

