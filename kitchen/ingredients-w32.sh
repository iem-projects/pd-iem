#!/bin/sh

## setup some environmental variables
SCRIPTDIR=${0%/*}


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
sudo apt-get update
sudo apt-get install binutils-mingw-w64-i686 gcc-mingw-w64-i686
#sudo apt-get install g++-mingw-w64-i686 wine



# 1.2 install Pd
if [ ! -e pd-${PDVERSION}.msw.zip ]; then
 wget http://msp.ucsd.edu/Software/pd-$(PDVERSION).msw.zip
fi
unzip pd-${PDVERSION}.msw.zip


