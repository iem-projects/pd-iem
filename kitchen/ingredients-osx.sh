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


## the actual work
# 0. setup all paths
BUILDDIR=$(ensuredir "${SCRIPTDIR}/../build")
if [ ! -d "${BUILDDIR}" ]; then error "no BUILDDIR"; exit 1; fi

# 1. install dependencies
cd "${BUILDDIR}"
# 1.1 update brew
## if BREW is not set (via env), set it to 'brew'
BREW=${BREW-brew}
error "using ${BREW} for 'brew'"
error "	you can override this by setting the BREW environmental variable"

${BREW} update
${BREW} install pkg-config
#${BREW} install gettext
#${BREW} link gettext --force
${BREW} install coreutils

# 1.2 install Pd
if [ ! -e pd-${PDVERSION}-64bit.mac.tar.gz ]; then
 wget http://msp.ucsd.edu/Software/pd-${PDVERSION}-64bit.mac.tar.gz
fi
tar -xf pd-${PDVERSION}-64bit.mac.tar.gz
ln -s "${BUILDDIR}/Pd-${PDVERSION}-64bit.app/Contents/Resources/" pd

# 1.X fix permissions
chmod -R u+rwX .

# 2. some Pd-extended externals prefer their headers in $(PD_PATH)/include/pdmkdir pd/include
mkdir pd/include
ln -s ../src pd/include/pd
