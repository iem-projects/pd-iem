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
SCRIPTDIR=$(ensuredir "${SCRIPTDIR}")
BUILDDIR=$(ensuredir "${SCRIPTDIR}/../build")
BASEDIR=$(ensuredir "${SCRIPTDIR}/..")
DESTDIR=$(ensuredir "${BASEDIR}/dist/pd-iem")
if [ ! -d "${SCRIPTDIR}" ]; then error "no SCRIPTDIR"; exit 1; fi
if [ ! -d "${BUILDDIR}" ]; then error "no BUILDDIR"; exit 1; fi
if [ ! -d "${BASEDIR}" ]; then error "no BASEDIR"; exit 1; fi
if [ ! -d "${DESTDIR}" ]; then error "no DESTDIR"; exit 1; fi


INSTALLSCRIPT="${0%.sh}-${TRAVIS_OS_NAME}.sh"

if [ -x "${INSTALLSCRIPT}" ]; then
 "${INSTALLSCRIPT}"
else
 error "no install-script found for: ${TRAVIS_OS_NAME}"
 error "assuming all is well"
fi
