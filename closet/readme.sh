#!/bin/sh

. ${0%/*}/common

error() {
    echo "$@" 1>&2
}

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

getrevision() {
    local REV
    local SHORTREV=$(git rev-parse --short HEAD 2>/dev/null)
    REV=$(git describe --long --tags 2>/dev/null | sed -e 's|-[^-]*$||')
    if [  -x "${REV}" ]; then
	REV="$(git rev-parse --short HEAD 2>/dev/null)-$(git rev-list --count HEAD 2>/dev/null)"
    fi
    test -z "$(git status --untracked-files=normal --porcelain 2>/dev/null)" || REV="${REV}*"
    echo "${REV}"
}


PDIEMVERSION=$(getrevision)
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
