#!/usr/bin/env python
import sys, os, time, parted, libmount, shutil, stat
import subprocess as sproc
try:
    import wget
except ImportError:
    print ("not import wget. Exit")
    exit
try:
    import pytz
except ImportError:
    print ("not import pytz. Exit")
    exit

#-----------------------data--------------------------------------------
WGET_LIST=["http://download.savannah.gnu.org/releases/acl/acl-2.2.52.src.tar.gz",
"http://download.savannah.gnu.org/releases/attr/attr-2.4.47.src.tar.gz",
"http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.xz",
"http://ftp.gnu.org/gnu/automake/automake-1.15.tar.xz",
"http://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz",
"http://alpha.gnu.org/gnu/bc/bc-1.06.95.tar.bz2",
"http://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.bz2",
"http://ftp.gnu.org/gnu/bison/bison-3.0.4.tar.xz",
"http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz",
"http://sourceforge.net/projects/check/files/check/0.10.0/check-0.10.0.tar.gz",
"http://ftp.gnu.org/gnu/coreutils/coreutils-8.25.tar.xz",
"http://dbus.freedesktop.org/releases/dbus/dbus-1.10.10.tar.gz",
"http://ftp.gnu.org/gnu/dejagnu/dejagnu-1.6.tar.gz",
"http://ftp.gnu.org/gnu/diffutils/diffutils-3.5.tar.xz",
"http://dev.gentoo.org/~blueness/eudev/eudev-3.2.tar.gz",
"http://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.43.3/e2fsprogs-1.43.3.tar.gz",
"http://prdownloads.sourceforge.net/expat/expat-2.2.0.tar.bz2",
"http://prdownloads.sourceforge.net/expect/expect5.45.tar.gz",
"ftp://ftp.astron.com/pub/file/file-5.28.tar.gz",
"http://ftp.gnu.org/gnu/findutils/findutils-4.6.0.tar.gz",
"https://github.com/westes/flex/releases/download/v2.6.1/flex-2.6.1.tar.xz",
"http://ftp.gnu.org/gnu/gawk/gawk-4.1.4.tar.xz",
"http://ftp.gnu.org/gnu/gcc/gcc-6.2.0/gcc-6.2.0.tar.bz2",
"http://ftp.gnu.org/gnu/gdbm/gdbm-1.12.tar.gz",
"http://ftp.gnu.org/gnu/gettext/gettext-0.19.8.1.tar.xz",
"http://ftp.gnu.org/gnu/glibc/glibc-2.24.tar.xz",
"http://ftp.gnu.org/gnu/gmp/gmp-6.1.1.tar.xz",
"http://ftp.gnu.org/gnu/gperf/gperf-3.0.4.tar.gz",
"http://ftp.gnu.org/gnu/grep/grep-2.26.tar.xz",
"http://ftp.gnu.org/gnu/groff/groff-1.22.3.tar.gz",
"http://alpha.gnu.org/gnu/grub/grub-2.02~beta3.tar.xz",
"http://ftp.gnu.org/gnu/gzip/gzip-1.8.tar.xz",
"http://anduin.linuxfromscratch.org/LFS/iana-etc-2.30.tar.bz2",
"http://ftp.gnu.org/gnu/inetutils/inetutils-1.9.4.tar.xz",
"http://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz",
"https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-4.7.0.tar.xz",
"https://www.kernel.org/pub/linux/utils/kbd/kbd-2.0.3.tar.xz",
"https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-23.tar.xz",
"http://www.greenwoodsoftware.com/less/less-481.tar.gz",
"http://www.linuxfromscratch.org/lfs/downloads/development/lfs-bootscripts-20150222.tar.bz2",
"https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/libcap-2.25.tar.xz",
"http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.4.1.tar.gz",
"http://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz",
"https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.8.9.tar.xz",
"http://ftp.gnu.org/gnu/m4/m4-1.4.17.tar.xz",
"http://ftp.gnu.org/gnu/make/make-4.2.1.tar.bz2",
"http://download.savannah.gnu.org/releases/man-db/man-db-2.7.5.tar.xz",
"https://www.kernel.org/pub/linux/docs/man-pages/man-pages-4.08.tar.xz",
"http://www.multiprecision.org/mpc/download/mpc-1.0.3.tar.gz",
"http://www.mpfr.org/mpfr-3.1.5/mpfr-3.1.5.tar.xz",
"http://ftp.gnu.org/gnu//ncurses/ncurses-6.0.tar.gz",
"http://ftp.gnu.org/gnu/patch/patch-2.7.5.tar.xz",
"http://www.cpan.org/src/5.0/perl-5.24.0.tar.bz2",
"https://pkg-config.freedesktop.org/releases/pkg-config-0.29.1.tar.gz",
"http://sourceforge.net/projects/procps-ng/files/Production/procps-ng-3.3.12.tar.xz",
"http://downloads.sourceforge.net/project/psmisc/psmisc/psmisc-22.21.tar.gz",
"http://ftp.gnu.org/gnu/readline/readline-7.0.tar.gz",
"http://ftp.gnu.org/gnu/sed/sed-4.2.2.tar.bz2",
"http://pkg-shadow.alioth.debian.org/releases/shadow-4.2.1.tar.xz",
"http://www.infodrom.org/projects/sysklogd/download/sysklogd-1.5.1.tar.gz",
"http://download.savannah.gnu.org/releases/sysvinit/sysvinit-2.88dsf.tar.bz2",
"http://ftp.gnu.org/gnu/tar/tar-1.29.tar.xz",
"http://sourceforge.net/projects/tcl/files/Tcl/8.6.6/tcl-core8.6.6-src.tar.gz",
"http://ftp.gnu.org/gnu/texinfo/texinfo-6.3.tar.xz",
"http://www.iana.org/time-zones/repository/releases/tzdata2016g.tar.gz",
"http://anduin.linuxfromscratch.org/LFS/udev-lfs-20140408.tar.bz2",
"https://www.kernel.org/pub/linux/utils/util-linux/v2.28/util-linux-2.28.2.tar.xz",
"ftp://ftp.vim.org/pub/vim/unix/vim-8.0.tar.bz2",
"http://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz",
"http://tukaani.org/xz/xz-5.2.2.tar.xz",
"http://www.zlib.net/zlib-1.2.8.tar.xz",
"http://www.linuxfromscratch.org/patches/lfs/7.10/bash-4.3.30-upstream_fixes-3.patch",
"http://www.linuxfromscratch.org/patches/lfs/7.10/bc-1.06.95-memory_leak-1.patch",
"http://www.linuxfromscratch.org/patches/lfs/7.10/bzip2-1.0.6-install_docs-1.patch",
"http://www.linuxfromscratch.org/patches/lfs/7.10/coreutils-8.25-i18n-2.patch",
"http://www.linuxfromscratch.org/patches/lfs/7.10/glibc-2.24-fhs-1.patch",
"http://www.linuxfromscratch.org/patches/lfs/7.10/kbd-2.0.3-backspace-1.patch",
"http://www.linuxfromscratch.org/patches/lfs/7.10/readline-6.3-upstream_fixes-3.patch",
"http://www.linuxfromscratch.org/patches/lfs/7.10/sysvinit-2.88dsf-consolidated-1.patch"
]
pushstack = list()
LFS = "/mnt/lfs"
TIMEZONE = "Europe/Rome"
FS = "ext4"
ROOT_PART = "" #"/dev/sdc5"
SWAP_PART = "" #"/dev/sdxx"
HOME_PART = "" #

#---------------------------functions----------------------------------#
def pushdir(dirname):
    global pushstack
    pushstack.append(os.getcwd())
    od.chdir(dirname)

def popdir():
    global pushstack
    os.chdir(pushstack.pop())

def getfile(url):
    filename = wget.download(url)
    return filename

def getlist(outdir, listfiles):
    pushdir(outdir)
    for i in listfiles:
        print ("Download " + i + " file")
        getfile(i)
    popdir()

def get_timezone():
    count = 0
    result = 0
    number = ""
    while number == "":
        for tz in pytz.common_timezones:
            count += 1
            print (str (count) + ")" + " " + tz)
            if count % 23 == 0:
                number = raw_input("Insert the number or return for others country: ")
                if number != "":
                    try:
                        result = int(number)
                        if result > len(pytz.common_timezones):
                            result = 0
                            continue
                    except:
                        result = 0
                        continue
                    break
        count = 0
    return pytz.timezone(pytz.common_timezones[result - 1])

def mount(source, target):
    cxt = libmount.Context()
    cxt.source = source
    cxt.target = target
    try:
        cxt.mount()
    except Exception:
        print("failed to mount " + source + " in " + target)
        return -1
    print("successfully mounted")
    return 0

def umount(target):
    cxt = libmount.Context()
    cxt.target = target
    try:
        cxt.umount()
    except Exception:
        print("failed to umount " + target)
        return -1
    print("successfully umounted")
    return 0

def mkfs(fs,dev):
    if fs=="" or dev == "":
        return -1
    cmd = []
    cmd.append("mkfs")
    cmd.append("-t")
    cmd.append(fs)
    cmd.append(dev)
    p = sproc.Popen(cmd, stdin=sproc.PIPE, stdout=sproc.PIPE, stderr=sproc.STDOUT, shell=False)
    p.stdin.write("y\n")
    line = p.stdout.readline()
    while line != "":
        sys.stdout.write(line)
        sys.stdout.flush()
        line = p.stdout.readline()
    return p.wait()

def mkswap(dev):
    if dev == "":
        return -1
    cmd = []
    cmd.append("mkswap")
    cmd.append(dev)
    p = sproc.Popen(cmd, stdin=sproc.PIPE, stdout=sproc.PIPE, stderr=sproc.STDOUT, shell=False)
    p.stdin.write("y\n")
    line = p.stdout.readline()
    while line != "":
        sys.stdout.write(line)
        sys.stdout.flush()
        line = p.stdout.readline()
    return p.wait()

def deltree(path):
    if path == "":
        exit -1
    cmd = []
    cmd.append("rm")
    cmd.append("-rvf")
    cmd.append(path)
    p = sproc.Popen(cmd, stdin=sproc.PIPE, stdout=sproc.PIPE, stderr=sproc.STDOUT, shell=False)
    line = p.stdout.readline()
    while line != "":
        sys.stdout.write(line)
        sys.stdout.flush()
        line = p.stdout.readline()
    return p.wait()

def isblkdev(dev):
    mode = os.stat(dev).st_mode
    if stat.S_ISBLK(mode):
        return True
    else:
        return False

#---------------------------stages-------------------------------------#
def stage1():
    TIMEZONE = get_timezone()
    deltree("/tools")
    deltree("/sources")
    deltree(LFS)
    f = open("build-properties", "a")
    f.write("LFS=%s" % LFS)
    if os.path.isfile(ROOT_PART) and isblkdev(ROOT_PART):
        ret = mkfs(FS, ROOT_PART)
        if ret != 0:
            print "Error!"
            exit(1)
    else:
        print "%s is not a valid block device. Aborting..." % ROOT_PART
        exit(1)
    os.makedirs(LFS)
    mount(ROOT_PART, LFS)
    if os.path.isfile(SWAP_PART) and isblkdev(SWAP_PART):
        ret = mkswap(SWAP_PART)
        if ret != 0:
            print "Swap partition exists and is active. Not formatting"
    else:
        print "No valid swap partition specified. Continuing without swap partition..."
    
#---------------------------main---------------------------------------#

if __name__ == "__main__":
    pass
#---------------------------tests--------------------------------------#
#for i in WGET_LIST:
#    print (i)
#print ("Download " + WGET_LIST[0] + " file")
#filename = getfile(WGET_LIST[0])
#TIMEZONE = get_timezone()
#print (TIMEZONE)
#mount("/dev/sdb5", "/mnt")
#raw_input("...")
#umount("/mnt")
#sdc = parted.getDevice("/dev/sdc")
#print(sdc.model)
#ret = mkfs("ext4", "/dev/sdc1")
#print (ret)
#ret = deltree("/home/marcellomortaro/symb")
#print(ret)
print isblkdev("/dev/sda1")
print isblkdev("/home/marcellomortaro/src/git/aryalinux/lfs/lfs.py")
