# SPDX-License-Identifier: MIT
#
# Copyright 2024 Beijing ESWIN Computing Technology Co., Ltd.
#

# Simple initramfs image. Mostly used for live images.
DESCRIPTION = "Small image capable of booting a device. The kernel includes \
the Minimal RAM-based Initial Root Filesystem (initramfs), which one can use \
to check the hardware efficiently."

PACKAGE_INSTALL = " busybox"
# Do not pollute the initrd image with rootfs features
IMAGE_FEATURES = ""

export IMAGE_BASENAME = "eswin-image-boot"
IMAGE_LINGUAS = ""

# Some BSPs use IMAGE_FSTYPES:<machine override> which would override
# an assignment to IMAGE_FSTYPES so we need anon python
python () {
    d.setVar("IMAGE_FSTYPES", d.getVar("INITRAMFS_FSTYPES"))
}

#do_rootfs:append(){
#	mkdir ${IMAGE_ROOTFS}/dev
#	mknod $(IMAGE_ROOTFS)/dev/console c 5 1
#	mknod $(IMAGE_ROOTFS)/dev/loop0 b 7 0
#}

inherit core-image

inherit extrausers
EXTRA_USERS_PARAMS = "useradd -p eswin eswin;"

IMAGE_ROOTFS_SIZE = "8192"
IMAGE_ROOTFS_EXTRA_SPACE = "0"

BAD_RECOMMENDATIONS += "busybox-syslog"
