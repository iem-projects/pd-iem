#!/bin/sh

## setup some environmental variables
SCRIPTDIR=${0%/*}
OS=$1

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

# 1. clear conf-file
CONFFILE="${BUILDDIR}/config.mk"
echo "# automatically generated config-file (makefile snippet)" > "${CONFFILE}"

INSTALLSCRIPT="${0%.sh}-${OS}.sh"

if [ -x "${INSTALLSCRIPT}" ]; then
 "${INSTALLSCRIPT}"
else
 error "no OS-specific install-script found ${INSTALLSCRIPT}"
 error "assuming all is well"
fi

PTHREAD_CHECK=${BASEDIR}/closet/check-pthread.sh
test -x "${PTHREAD_CHECK}" && "${PTHREAD_CHECK}" && echo "HAVE_PTHREADS=1" >> "${CONFFILE}"


exit 0
