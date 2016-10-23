ABOUT PROJECT

This project stores all the scripts that are used to build AryaLinux from scratch

There are three parts to building Aryalinux:
1) Base System
2) X Server and Desktop Environment
3) Applications

BASE SYSTEM

The base System is roughly the same as the system one would end up building by following
the LFS book. Apart from the packages listed in LFS, in the base system that Aryalinux
consists of are the following packages and their dependencies:

 * wget
 * sudo
 * os-prober
 * busybox
 * dracut

Each of these packages has a definite purpose and reason for being included in the base-system
just as each package that gets built and installed before it. Wget is used to download the source
tarballs for the various packages that would help build the system. Sudo helps in user rights
management. Since packages are built as regular user and installed as the root user, sudo makes
executing the install commands easier. os-prober helps in detecting the various operating systems
that are installed in the hard disk other than AryaLinux so that they can be listed during boot.
Busybox is used in the initrd. Dracut immensely simplifies the process of creating initrd.

The base system can be built by running the following command:

./build-arya

This command runs several scripts which in turn build part of the complete system.
Once all the scripts complete execution, the base system would be built and installed and
one could boot into it. If the script is instructed to build x-server and desktop environments then
it would go ahead and build/install xserver and the desktop environment.

APPLICATIONS

After Desktop Environment is built, applications can be built depending on the preferences of
the user. Applications that can be installed in this stage are:

 * Internet Applications (firefox, thunderbird, pidgin, hexchat, transmission)
 * Multimedia Players (VLC, mplayer, audacious)
 * Libreoffice
 * Other applications (gimp, xfburn etc..)

HOW TO USE THE SCRIPTS

Download the scripts into the /root directory inside a directory named scripts. So all scripts
in the scripts directory should be present in /root/scripts. Then execute the following commands:

cd scripts
./download-sources.sh
./additional-downloads.sh
./1.sh

As soon as 1.sh is executed you would be asked for several inputs in an interactive manner. Just
enter the details asked for and wait for the scripts to finish one by one. When one script would
end, it would print instructions to run the next script. Just follow the instructions as given.
Once 4.sh finishes, your system would be ready. You can reboot to log into the new system.

Once this is done, to build the rest of the system you can follow our online documentation that
is available in aryalinux.org/documentation/

* Boot into the system that you used to build Aryalinux. In case your grub menu does not show that
option any more, just boot into AryaLinux and run this command:

grub-mkconfig -o /boot/grub/grub.cfg

* Packages can now be installed using the following command:

alps install <package-name>
