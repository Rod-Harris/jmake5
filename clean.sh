#!/bin/bash

#
# Version: 1.1
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

#
# This compile starts here
#

if [ -e ./target ]; then
	rm -rvf ./target >&2
fi

if [ "${1:-}" = "-a" ]; then
	rm -rvf "$TARGET_DIR_PARENT" >&2
	rm -vf $INSTALL_LIB_DIR/$jp5pkg*.jar
fi

echo "Clean OK" >&2

exit 0

# Version: 1.0
# Created: 2024-07-07
