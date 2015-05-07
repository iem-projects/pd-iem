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

getbuildsys() {
    if which lsb_release >/dev/null; then
	echo "$(lsb_release -sd) [$(uname -m)]"
	return
    fi
    if which sw_vers >/dev/null; then
	echo "OSX-$(sw_vers -productVersion) [$(uname -m)]"
    fi
}

fill_template() {
    sed \
	-e "s|@LIBRARIES@|${LIBRARIES}|g" \
	-e "s|@VERSION@|${VERSION}|g" \
	-e "s|@OS@|${TARGETOS}|g" \
	-e "s|@PDVERSION@|${PDVERSION}|g" \
	-e "s|@BUILDHOST@|${BUILDHOST}|g" \
	-e "s|@BUILDSYS@|${BUILDSYS}|g" \
	-e "s|@TIMESTAMP@|${TIMESTAMP}|g"
}

assemble() {
    while [ $# -gt 0 ]; do
	cat "$1"
	shift
	if [ $# -gt 0 ]; then
	    echo
	    echo
	fi
    done
}

VERSION=$(getrevision)
PDVERSION=$(getpdversion)
LIBRARIES=""
for l in $(getlibraries); do
    LIBRARIES="${LIBRARIES}\\
  - ${l}"
done
TIMESTAMP=$(LANG=C date)
BUILDHOST=$(hostname)
BUILDSYS=$(getbuildsys)
TEMPLATEDIR="${SCRIPTDIR}/../templates"
TARGETOS=$(echo ${OS} | tr '[a-z]' '[A-Z]')

error iem : ${VERSION}
error OS  : ${OS}
error Pd  : ${PDVERSION}
error libs: ${LIBRARIES}
error host: ${BUILDHOST}
error sys : ${BUILDSYS}

assemble "${TEMPLATEDIR}/README.top.md" "${TEMPLATEDIR}/README.${OS}" "${TEMPLATEDIR}/README.bottom.md" \
    | fill_template
