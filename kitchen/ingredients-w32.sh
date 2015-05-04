#!/bin/sh

## setup some environmental variables
SCRIPTDIR=${0%/*}
PDVERSION=0.46-6


## some helper functions
error() {
 echo "$@" 1>&2
}
ensuredir() {
   mkdir -p "$1" 2>/dev/null && cd "$1" && pwd
}

## if SUDO is not set (via env), set it to 'sudo'
SUDO=${SUDO-sudo}


## the actual work
# 0. setup all paths
BUILDDIR=$(ensuredir "${SCRIPTDIR}/../build")
if [ ! -d "${BUILDDIR}" ]; then error "no BUILDDIR"; exit 1; fi

# 1. install dependencies
cd "${BUILDDIR}"
# 1.1 install MinGW64 toolchain
${SUDO} apt-get update
${SUDO} apt-get install binutils-mingw-w64-i686 gcc-mingw-w64-i686
${SUDO} apt-get install mingw-w64-i686-dev || ${SUDO} apt-get install mingw-w64-dev
${SUDO} apt-get install mingw-w64-tools
#${SUDO} apt-get install mingw-w64
#${SUDO} apt-get install g++-mingw-w64-i686 wine



# 1.2 install Pd
if [ ! -e pd-${PDVERSION}.msw.zip ]; then
 wget http://msp.ucsd.edu/Software/pd-${PDVERSION}.msw.zip
fi
unzip -qo pd-${PDVERSION}.msw.zip

## some Pd-extended externals prefer their headers in $(PD_PATH)/include/pd
mkdir -p pd/include
if [ ! -e pd/include/pd ]; then
 ln -s ../src pd/include/pd
fi

# delete dll's shipped with Pd
find pd -iname "msvcrt.dll" -exec mv '{}' '{}.bak' ';'
