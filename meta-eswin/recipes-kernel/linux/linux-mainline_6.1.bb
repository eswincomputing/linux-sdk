FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
require recipes-kernel/linux/linux-mainline-common.inc

LINUX_VERSION ?= "6.1.50"
KERNEL_VERSION_SANITY_SKIP="1"
PV = "${LINUX_VERSION}+git${SRCPV}"

BRANCH = "linux-6.1.y"
#SRCREV = "${AUTOREV}"
SRCREV = "7d24402875c75ca6e43aa27ae3ce2042bde259a4"
SRCPV = "${@bb.fetch2.get_srcrev(d)}"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git;branch=${BRANCH} \
    file://fragment.cfg \
    file://0001-S500-bringup.patch \
"

KBUILD_DEFCONFIG = "defconfig"

BUILD_CFLAGS += "-g"

COMPATIBLE_MACHINE = "S500"
