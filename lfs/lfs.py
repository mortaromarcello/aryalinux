#!/usr/bin/env python
import sys, os, parted, shutil, libmount, stat, glob, pwd
import subprocess as sproc
from subprocess import check_output

try:
    from pychroot import Chroot
except ImportError:
    print ("not import pychroot. Exit")
    exit(-1)

try:
    import wget
except ImportError:
    print ("not import wget. Exit")
    exit(-1)

try:
    import pytz
except ImportError:
    print ("not import pytz. Exit")
    exit(-1)

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
"http://www.linuxfromscratch.org/patches/lfs/7.10/sysvinit-2.88dsf-consolidated-1.patch",
############# Additional downloads###########
"http://pkgs.fedoraproject.org/lookaside/pkgs/dosfstools/dosfstools-3.0.26.tar.xz/45012f5f56f2aae3afcd62120b9e5a08/dosfstools-3.0.26.tar.xz",
"http://ftp.gnu.org/gnu/which/which-2.21.tar.gz",
"http://ftp.de.debian.org/debian/pool/main/o/os-prober/os-prober_1.71.tar.xz",
"http://pkgs.fedoraproject.org/repo/pkgs/efivar/efivar-0.23.tar.bz2/bff7aa95fdb2f5d79f4aa9721dca2bbd/efivar-0.23.tar.bz2",
"http://pkgs.fedoraproject.org/repo/pkgs/efibootmgr/efibootmgr-0.12.tar.bz2/6647f5cd807bc8484135ba74fcbcc39a/efibootmgr-0.12.tar.bz2",
"http://downloads.sourceforge.net/freetype/freetype-2.6.3.tar.bz2",
"http://unifoundry.com/pub/unifont-7.0.05/font-builds/unifont-7.0.05.pcf.gz",
"http://pkgs.fedoraproject.org/repo/pkgs/pciutils/pciutils-3.4.1.tar.gz/acc91d632dbc98f624a8e57b4e478160/pciutils-3.4.1.tar.gz",
"http://pkgs.fedoraproject.org/repo/pkgs/popt/popt-1.16.tar.gz/3743beefa3dd6247a73f8f7a32c14c33/popt-1.16.tar.gz",
"http://pkgs.fedoraproject.org/repo/pkgs/linux-firmware/linux-firmware-20160321.tar.gz/46a7ec26850851c9da93ba84dd14fc71/linux-firmware-20160321.tar.gz",
"http://ftp.gnu.org/pub/gnu/cpio/cpio-2.12.tar.bz2",
"http://pkgs.fedoraproject.org/repo/pkgs/redhat-lsb/lsb-release-1.4.tar.gz/30537ef5a01e0ca94b7b8eb6a36bb1e4/lsb-release-1.4.tar.gz",
"https://busybox.net/downloads/fixes-1.20.2/busybox-1.20.2-sys-resource.patch",
"https://busybox.net/downloads/busybox-1.20.2.tar.bz2",
"https://ftp.gnu.org/gnu/nettle/nettle-3.1.1.tar.gz",
"http://ftp.gnu.org/gnu/libtasn1/libtasn1-4.5.tar.gz",
"http://p11-glue.freedesktop.org/releases/p11-kit-0.23.2.tar.gz",
"ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-3.4.3.tar.xz",
"http://ftp.gnu.org/gnu/wget/wget-1.16.3.tar.xz",
"http://www.sudo.ws/dist/sudo-1.8.16.tar.gz",
"ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz",
"http://sqlite.org/2016/sqlite-autoconf-3140100.tar.gz",
"https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tar.xz",
"https://ftp.dlitz.net/pub/dlitz/crypto/pycrypto/pycrypto-2.6.1.tar.gz",
"http://anduin.linuxfromscratch.org/sources/other/certdata.txt",
"http://www.openssl.org/source/openssl-1.0.2j.tar.gz",
"http://www.kernel.org/pub/linux/utils/boot/syslinux/syslinux-4.06.tar.xz",
#"http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.8.tar.gz",
"https://www.kernel.org/pub/linux/utils/boot/dracut/dracut-044.tar.xz",
"ftp://sources.redhat.com/pub/lvm2/releases/LVM2.2.02.155.tgz"
]
pushstack = list()
LFS = "%s/lfs" % os.environ["HOME"]
LC_ALL='POSIX'
LFS_TGT=sproc.check_output("echo $(uname -m)-lfs-linux-gnu", shell=True).strip('\n')
TIMEZONE = "Europe/Rome"
FS = "ext4"
ROOT_PART = "" #"/dev/sdc5"
SWAP_PART = "" #"/dev/sdxx"
HOME_PART = "" #
FORMAT_HOME = False
env = {}
PATH="%s/tools/bin:%s/bin:%s/usr/bin" % (LFS, LFS, LFS)
env['LFS'] = LFS
env['LC_ALL'] = LC_ALL
env['PATH'] = PATH
env['LFS_TGT']=LFS_TGT

#---------------------------build-packages-----------------------------#
def build_binutils(step, srcdir, tarball):
    if step == 1:
        prefix = "%s/tools" % LFS
    elif step == 2:
        prefix = LFS
    os.chdir(srcdir)
    if tarball:
        directory = os.path.splitext(os.path.splitext(tarball)[0])[0]
        if os.path.exists(directory):
            deltree(directory)
        run_cmd("tar xvf %s" % tarball)
        os.chdir(directory)
        run_cmd("mkdir -pv build")
        os.chdir("build")
        if step == 1:
            run_cmd("../configure --prefix=%s --with-sysroot=%s --with-lib-path=%s/tools/lib --target=%s --disable-nls --disable-werror" % (prefix, LFS, LFS, LFS_TGT))
        elif step == 2:
            run_cmd("CC=$LFS_TGT-gcc AR=$LFS_TGT-ar RANLIB=$LFS_TGT-ranlib ./configure --prefix=%s --disable-nls -disable-werror --with-lib-path=%s/lib --with-sysroot" % (LFS, LFS), env)
        run_cmd("make")
        if os.uname()[4] == "x86_64":
            run_cmd("mkdir -pv %s/tools/lib && ln -sv lib %s/tools/lib64 ;;" % (LFS, LFS))
        run_cmd("make install")

def build_gcc(step, srcdir, tarball):
    if step == 1:
        prefix = "%s/tools" % LFS
    elif step == 2:
        prefix = LFS
    os.chdir(srcdir)
    if tarball:
        directory = os.path.splitext(os.path.splitext(tarball)[0])[0]
        if os.path.exists(directory):
            deltree(directory)
        run_cmd("tar xvf %s" % tarball)
        os.chdir(directory)
        run_cmd("tar -xvf ../mpfr-3.1.5.tar.xz")
        run_cmd("mv -v mpfr-3.1.5 mpfr")
        run_cmd("tar -xvf ../gmp-6.1.1.tar.xz")
        run_cmd("mv -v gmp-6.1.1 gmp")
        run_cmd("tar -xvf ../mpc-1.0.3.tar.gz")
        run_cmd("mv -v mpc-1.0.3 mpc")
        for nfile in check_output("find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h".split()).split():
            run_cmd("cp -uv %s{,.orig}" % nfile)
            run_cmd("sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' -e 's@/usr@/tools@g' %s.orig > %s" % (nfile, nfile))
            f = open(nfile, 'a')
            f.write("#undef STANDARD_STARTFILE_PREFIX_1")
            f.write("#undef STANDARD_STARTFILE_PREFIX_2")
            f.write("#define STANDARD_STARTFILE_PREFIX_1 \"%s/lib/\"" % prefix)
            f.write("#define STANDARD_STARTFILE_PREFIX_2 \"\"")
            f.close()
        run_cmd("mkdir -pv build")
        os.chdir("build")
        if step == 1:
            run_cmd("../configure --prefix=%s --with-glibc-version=2.11 --with-sysroot=%s --with-newlib --without-headers --with-local-prefix=%s --with-native-system-header-dir=%s/include --disable-nls --disable-shared --disable-multilib --disable-decimal-float --disable-threads --disable-libatomic --disable-libgomp --disable-libmpx --disable-libquadmath --disable-libssp --disable-libvtv --disable-libstdcxx --enable-languages=c,c++ --target=%s" % (prefix, LFS, prefix, prefix, LFS_TGT))
        elif step == 2:
            pass
        run_cmd("make")
        if os.uname()[4] == "x86_64":
            run_cmd("mkdir -pv %s/tools/lib && ln -sv lib %s/tools/lib64 ;;" % (LFS, LFS))
        run_cmd("make install")
    
#---------------------------functions----------------------------------#
def demote(user_uid, user_gid):
    def result():
        os.setgid(user_gid)
        os.setuid(user_uid)
    return result

def pushdir(dirname):
    global pushstack
    pushstack.append(os.getcwd())
    os.chdir(dirname)

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
        if not os.path.exists(os.path.basename(i)):
            getfile(i)
        else:
            print ("File %s already exists." % os.path.basename(i))
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
        exit(-1)
    run_cmd("rm -rvf %s" % path)

def run_with_env_as(user, cmds, env, cwd):
    userRecord = pwd.getpwnam(user)
    userUid = userRecord.pw_uid
    userGid = userRecord.pw_gid
    p = sproc.Popen(cmds.split(), stdin=sproc.PIPE, stdout=sproc.PIPE, stderr=sproc.STDOUT, preexec_fn=demote(userUid, userGid), cwd=cwd, env=env, shell=False)
    line = p.stdout.readline()
    while line != "":
        sys.stdout.write(line)
        sys.stdout.flush()
        line = p.stdout.readline()
    return p.wait()

def run_cmd(cmd, env=""):
    if env:
        p = sproc.Popen(cmd.split(), stdin=sproc.PIPE, stdout=sproc.PIPE, stderr=sproc.STDOUT, env=env, shell=False)
    else:
        p = sproc.Popen(cmd.split(), stdin=sproc.PIPE, stdout=sproc.PIPE, stderr=sproc.STDOUT, shell=False)
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

def download_sources():
    try:
        os.makedirs('%s/sources' % os.environ['HOME'])
    except:
        print("Directory exists. Ignore.")
    getlist('%s/sources' % os.environ['HOME'], WGET_LIST)

#---------------------------stages-------------------------------------#
def stage1():
    global TIMEZONE
    TIMEZONE = get_timezone()
    deltree("/tools")
    deltree("/sources")
    deltree(LFS)
    f = open("build-properties", "a")
    f.write("TIMEZONE=%s" % TIMEZONE)
    f.write("LFS=%s" % LFS)
    if os.path.isfile(ROOT_PART) and isblkdev(ROOT_PART):
        ret = mkfs(FS, ROOT_PART)
        if ret != 0:
            print "Error!"
            exit(-1)
    else:
        print "%s is not a valid block device. Aborting..." % ROOT_PART
        exit(-1)
    os.makedirs(LFS)
    mount(ROOT_PART, LFS)
    if os.path.isfile(SWAP_PART) and isblkdev(SWAP_PART):
        ret = mkswap(SWAP_PART)
        if ret != 0:
            print "Swap partition exists and is active. Not formatting"
    else:
        print "No valid swap partition specified. Continuing without swap partition..."
    if os.path.isfile(HOME_PART) and isblkdev(HOME_PART) and HOME_PART != ROOT_PART:
        if FORMAT_HOME:
            mkfs(FS, HOME_PART)
        mount(HOME_PART, "%s/home" % LFS)
    else:
        print "No valid and different home partition specified. Continuing with home on root partition..."
    os.makedirs("%s/sources" % LFS)
    os.chmod("%s/sources" % LFS, 0o777)
    os.symlink("%s/sources" % LFS, "/sources")
    shutil.copytree("%s/sources/*" % os.environ['HOME'], "%s/sources" % LFS)
    f = open("%s/sources/currentstage" % LFS, "w")
    f.close()
    os.makedirs("%s/tools" % LFS)
    os.symlink("%s/tools" % LFS, "/")
    os.makedirs("%s/var/cache/alps/sources" % LFS)
    if os.path.isdir("%s/sources-apps" % os.environ['HOME']):
        shutil.copytree("%s/sources-apps/*" % os.environ['HOME'], "%s/var/cache/alps/sources/" % LFS)
        for root,dirs,files in os.walk("%s/var/cache/alps/sources" % LFS):
            for name in files:
                st = os.stat(name)
                os.chmod(name, st.st_mode | stat.S_IWUSR | stat.S_IRUSR | stat.S_IWGRP | stat.S_IRGRP | stat.S_IWOTH | stat.S_IROTH)
            for name in dirs:
                st = os.stat(name)
                os.chmod(name, st.st_mode | stat.S_IWUSR | stat.S_IRUSR | stat.S_IWGRP | stat.S_IRGRP | stat.S_IWOTH | stat.S_IROTH)
    if 'lfs' in open('/etc/passwd').read():
        run_cmd("userdel -r lfs")
    run_cmd("groupadd lfs")
    run_cmd("useradd -s /bin/bash -g lfs -m -k /dev/null lfs")
    run_cmd("chown -R lfs:lfs /home/lfs/*")
    run_cmd("chown -R lfs:lfs /sources/*")
    run_cmd("chown -R lfs:lfs /home/lfs")

def stage2():
    global env
    for name in glob.glob('/sources/toolchain/*.sh'):
        run_with_env_as('lfs', name, env, '/home/lfs')

def stage3():
    run_cmd("chown -R root:root %s/tools" % LFS)
    for name in ['dev', 'proc', 'sys', 'run']:
        os.makedirs("%s/%s" % (LFS, name), True)
    if not os.path.exists("%s/dev/console" % LFS):
        run_cmd("mknod -m 600 %s/dev/console c 5 1" % LFS)
    if not os.path.exists("%s/dev/null" % LFS):
        run_cmd("mknod -m 600 %s/dev/null c 1 3" % LFS)
    run_cmd("mount -v --bind /dev %s/dev" % LFS)
    run_cmd("mount -vt devpts devpts %s/dev/pts -o gid=5 mode=620" % LFS)
    run_cmd("mount -vt proc proc %s/proc" % LFS)
    run_cmd("mount -vt sysfs sysfs %s/sys" % LFS)
    run_cmd("mount -vt tmpfs tmpfs %s/run" % LFS)
    if os.path.exists("%s/dev/shm" % LFS):
        os.makedirs("%s/%s" % (LFS, os.readlink("%s/dev/shm" % LFS)))

def stage4():
    with Chroot(LFS):
        run_cmd("mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}")
        run_cmd("mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}")
    

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
#run_cmd(['mkdir', '-pv', '/home/marcellomortaro/chroot/bin'])
#shutil.copy2('/bin/mkdir', '/home/marcellomortaro/chroot/bin')
#shutil.copy2('/bin/bash', '/home/marcellomortaro/chroot/bin')

#try:
#    run_cmd(['mkdir', '-pv', '/home/marcellomortaro/chroot'])
#    with Chroot('/home/marcellomortaro/chroot'):
#        run_cmd(['mkdir', '-pv', '/{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}'])
#        print os.getcwd()
#except:
#    print "error"
#os.chroot('/home/marcellomortaro/chroot')
#run_cmd(['mkdir', '-pv', '/{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}'])
#print os.getcwd()
#download_sources()

build_binutils(1, "%s/sources" % os.environ["HOME"], "binutils-2.27.tar.bz2")
build_gcc(1, "%s/sources" % os.environ["HOME"], "gcc-6.2.0.tar.bz2")

