#!/bin/sh
#
# This script takes a binary file and an optional relative path (with resp. to the file),
# and puts all non-standard dependencies of the binary into that relative path
# and makes the binary use these.
# based on pastyroll-osx.sh
#  originally written by  <hans@at.or.at>
#  hacked upon by <zmoelnig@iem.at>
#

error() {
    echo "$@" 1>&2
}
if [ $# -lt 2 ]; then
    error "Usage: $0 <embedpath> <binary> ..."
    error "   <embedpath> is ignored (things end up besides <binary>)"
    error "  i.e. $0 libs tmp/foo.exe tmp/bar.dll"
    error "         puts all dependencies of foo.exe and bar.dll into tmp/"
    error "  i.e. $0 "" tmp/libs/libgoo.dll"
    error "         puts all dependencies into tmp/libs"
    exit 0
fi

RELPATH=$1
shift

error "searching for embeddable libraries in $(pwd)"
ls
error "checking for FFTW-library"
ls fftw

count=0
while [ 0 -lt $# ]; do
    bin=$1
    shift
    dir=${bin%/*}/${RELPATH}
    for lib in $(i686-w64-mingw32-objdump -x ${bin} | sed -n -e '/DLL Name:/p' | cut -d' ' -f3); do
	if [  -e "${dir}/${lib}" ]; then
	    error "skipping local copy of already existing library ${lib}"
	else
	    ## search for the library
	    error "copying '$(pwd)/.../${lib}' to '${dir}'"
	    find . -iname "${lib}"

	    find . -iname "${lib}" -exec cp -v \{\} "${dir}" \;
	    if [  -e "${dir}/${lib}" ]; then
		error "installed '${lib}' into '${dir}'"
		count=$((count+1))
	    else
		error "skipping unfound dependency ${lib}"
	    fi
	fi
    done
done

exit ${count}
