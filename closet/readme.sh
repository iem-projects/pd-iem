#!/bin/sh

. ${0%/*}/common

getlibraries() {
    for lib in "${SCRIPTDIR}/../recipes"/*."${OS}"; do
        lib=${lib##*/}
        lib=${lib%.*}
        echo ${lib}
    done | sort
}

getpdversion() {
    find "${PDDIR}/" -name pd.rc -exec egrep 'VALUE.*"ProductVersion", "' \{\} \; \
        | sed -e 's|^.*, "||' -e 's|".*||' \
        | sort | tail -1
}


PDIEMVERSION=?
PDVERSION=$(getpdversion)
LIBRARIES=$(getlibraries)
TIMESTAMP=$(LANG=C date)
BUILDHOST=$(hostname)
BUILDSYS=?

echo iem : ${PDIEMVERSION}
echo OS  : ${OS}
echo Pd  : ${PDVERSION}
echo libs: ${LIBRARIES}
echo host: ${BUILDHOST}
echo sys : ${BUILDSYS}
