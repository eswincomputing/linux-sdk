#!/bin/bash

DIR="build"
MACHINE="S500"
CONFFILE="conf/auto.conf"
BITBAKEIMAGE="eswin-image-full-cmdline"
pwd=${PWD}

# Reconfigure dash on debian-like systems
which aptitude > /dev/null 2>&1
ret=$?
if [ "$(readlink /bin/sh)" = "dash" -a "$ret" = "0" ]; then
  sudo aptitude install expect -y
  expect -c 'spawn sudo dpkg-reconfigure -freadline dash; send "n\n"; interact;'
elif [ "${0##*/}" = "dash" ]; then
  echo "dash as default shell is not supported"
  return
fi

export BB_ENV_PASSTHROUGH_ADDITIONS="$BB_ENV_PASSTHROUGH_ADDITIONS PLAT"

# bootstrap OE
echo "Init OE"
export BASH_SOURCE="openembedded-core/oe-init-build-env"
. ./openembedded-core/oe-init-build-env $DIR


# add the missing layers
echo "Adding layers"
bitbake-layers add-layer ../openembedded-core/meta
bitbake-layers add-layer ../meta-openembedded/meta-oe
bitbake-layers add-layer ../meta-openembedded/meta-python
bitbake-layers add-layer ../meta-openembedded/meta-networking
bitbake-layers add-layer ../meta-eswin

# fix the configuration
echo "Creating auto.conf"

if [ -e $CONFFILE ]; then
    rm -rf $CONFFILE
fi
cat <<EOF > $CONFFILE
MACHINE ?= "${MACHINE}"
BB_NUMBER_THREADS = '16'
PARALLEL_MAKE = '-j 16'
#DISTRO_FEATURES:remove= "bluetooth usbgadget usbhost wifi nfs pci 3g nfc"
#DISTRO_FEATURES:append = " systemd opengl wayland pam"
#DISTRO_FEATURES_BACKFILL_CONSIDERED += "sysvinit"
#VIRTUAL-RUNTIME_init_manager = "systemd"
#EXTRA_IMAGE_FEATURES:append = " package-management"
#TCMODE = "external-riscv64"
INHERIT += "buildhistory"
BUILDHISTORY_COMMIT = "1"
EOF

echo "---------------------------------------------------"
echo "Example: MACHINE=${MACHINE} PLAT=s2c/haps/zebu bitbake eswin-image-boot"
echo "Example: MACHINE=${MACHINE} PLAT=s2c/haps/zebu bitbake ${BITBAKEIMAGE}"
echo "---------------------------------------------------"
echo ""
echo "Buildable machine info"
echo "---------------------------------------------------"
echo "* S500                     : The 64-bit RISC-V machine"
echo "---------------------------------------------------"

# start build
#echo "Starting build"
#bitbake $BITBAKEIMAGE

