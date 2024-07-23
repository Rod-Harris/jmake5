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

echo "Loading JProject5 App Info Last Compile Info.." >&2 
. "$(dirname $(readlink -f $0))/.common/02.sh"

#
# This build starts here
#

echo "Creating New Build.." >&2

# Create target directory
DS=$(date +%F)
echo "DS: [$DS]" >&2

TS=$(date +%H:%M:%S)
echo "TS: [$TS]" >&2

DTS="[$DS]-[$TS]"
echo "DTS: $DTS" >&2

version_build=$(printf "$version.%03d" $build)
echo "version_build: [$version_build]" >&2

target_build_dir="$TARGET_DIR_PARENT/$DTS-[$version_build]-[Build]"
echo "target_build_dir: $target_build_dir" >&2

mkdir -p $target_build_dir
mkdir -p target

if [ -e ./target/build ]; then
    echo "Unlinking old compile directory" >&2
    unlink ./target/build
fi

ln -s "$target_build_dir" ./target/build

mkdir -v target/build/class
mkdir -v target/build/lib

echo "JAR_DEPS: $JAR_DEPS" >&2

echo "Extracting dependencies" >&2
OLD_IFS=IFS
IFS=':' read -ra jars <<< "$JAR_DEPS"
for jar in "${jars[@]}"; do
    echo "Extracting $jar to target/build/class" >&2
    unzip -o -q "$jar" -d target/build/class
done
echo "Done" >&2
IFS=OLD_IFS

echo "TODO: copy NATIVE_DEPS to target/run/lib dir" >&2

echo "Remove all META-INF directories from ./target/build/class" >&2
find target/build/class -type d -name "META-INF" -exec rm -rf {} +
echo "META-INF directories removed" >&2

echo "Extracting ./target/compile/lib/$jp5pkg.jar to target/build/class" >&2
unzip -o -q "./target/compile/lib/$jp5pkg.jar" -d target/build/class
echo "Done" >&2

cd target/build/class

jar --create --file "../lib/$jp5pkg-$version_build.jar" --main-class "$JP5_APP_MAIN" -C . .

if [ $? -ne 0 ]; then
	echo "Couldn't create $jp5pkg-$version_build.jar file" >&2
	exit 1
fi

cd ../lib/

ln -s "./$jp5pkg-$version_build.jar" "$jp5pkg.jar"

ls -lh * >&2

echo "Build OK" >&2

exit 0

# Version: 1.0
# Created: 2024-07-18
