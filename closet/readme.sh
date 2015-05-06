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
    done | sort | while read l; do
		      echo -n "  - ${l}\\\\n"
		  done
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
	echo $(lsb_release -sd) $(uname -m)
	return
    fi
    if which sw_vers >/dev/null; then
	echo "OSX-"$(sw_vers -productVersion | awk -F '.' '{print $1 "." $2}') $(uname -m)
    fi
}


VERSION=$(getrevision)
PDVERSION=$(getpdversion)
LIBRARIES=$(getlibraries)
TIMESTAMP=$(LANG=C date)
BUILDHOST=$(hostname)
BUILDSYS=$(getbuildsys)

echo iem : ${VERSION}
echo OS  : ${OS}
echo Pd  : ${PDVERSION}
echo libs: $(LIBRARIES)
echo host: ${BUILDHOST}
echo sys : ${BUILDSYS}

cat "${SCRIPTDIR}/../templates/README.${OS}" | sed \
  -e "s|@LIBRARIES@|${LIBRARIES}|g" \
  -e "s|@VERSION@|${VERSION}|g" \
  -e "s|@OS@|${OS}|g" \
  -e "s|@PDVERSION@|${PDVERSION}|g" \
  -e "s|@BUILDHOST@|${BUILDHOST}|g" \
  -e "s|@BUILDSYS@|${BUILDSYS}|g" \
  -e "s|@TIMESTAMP@|${TIMESTAMP}|g"
