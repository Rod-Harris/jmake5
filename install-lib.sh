#!/bin/bash

#
# Version: 1.0
# Created: 2024-07-21
# Updated:
#
# TODO:
#

if [ "${1:-}" = "-x" ]; then
    set -x
    shift
fi
set -e
set -u

echo "Loading JProject5 App Development Version Info.." >&2 
. "$(dirname $(readlink -f $0))/.common/01.sh"

echo "Loading JProject5 App Info Last Compile Info.." >&2 
. "$(dirname $(readlink -f $0))/.common/02.sh"

#
# This install starts here
#

echo "Creating New Install.." >&2

if [ ! -d "$INSTALL_LIB_DIR" ]; then
    echo "You Shall Not Pass: INSTALL_LIB_DIR directory not found [$INSTALL_LIB_DIR]" >&2
    exit 1
fi
echo "INSTALL_LIB_DIR: [$INSTALL_LIB_DIR]" >&2

if [ -e "$INSTALL_LIB_DIR/$jp5pkg.jar" ]; then
    echo "You Shall Not Pass: INSTALL_LIB_DIR directory already has a version of this library installed" >&2
    exit 1
fi

version_build=$(printf "$version.%03d" $build)
echo "version_build: [$version_build]" >&2

cp ./target/compile/lib/$jp5pkg*.jar "$INSTALL_LIB_DIR/" >&2
#cp "./target/compile/lib/$jp5pkg-$version_build.jar" "$INSTALL_LIB_DIR/" >&2

cd "$INSTALL_LIB_DIR"

#ln -s $jp5pkg-$version_build.jar $jp5pkg.jar

ls -lh --color=auto $INSTALL_LIB_DIR/$jp5pkg*.jar

echo "Install OK" >&2
	
exit 0
