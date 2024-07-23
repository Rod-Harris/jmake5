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

# Find all Java files
JAVA_FILES=$(find "./src/rojira/$jp5pkg" -name "*.java")
echo "JAVA_FILES: [$JAVA_FILES]" >&2

if [ -z "$JAVA_FILES" ]; then
    echo "You Shall Not Pass: No Java files found to compile" >&2
    exit 1
fi

echo "Creating New Compile.." >&2

# Create target directory
DS=$(date +%F)
echo "DS: [$DS]" >&2

TS=$(date +%H:%M:%S)
echo "TS: [$TS]" >&2

DTS="[$DS]-[$TS]"
echo "DTS: $DTS" >&2

version_build=$(printf "$version.%03d" $build)
echo "version_build: [$version_build]" >&2

target_compile_dir="$TARGET_DIR_PARENT/$DTS-[$version_build]-[Compile]"
echo "target_compile_dir: $target_compile_dir" >&2

mkdir -p $target_compile_dir
mkdir -p target

if [ -e ./target/compile ]; then
    echo "Unlinking old compile directory" >&2
    unlink ./target/compile
fi

ln -s $target_compile_dir ./target/compile

mkdir target/compile/class
mkdir target/compile/lib

echo "Checking dependencies..." >&2
OLD_IFS=IFS
IFS=':' read -ra jars <<< "$JAR_DEPS"
for jar in "${jars[@]}"; do
    echo "Checking [$jar]" >&2
    if [ ! -f "$jar" ]; then
		echo "You Shall Not Pass: Dependency Not Found: [$jar]" >&2
		exit 1
    fi
done
IFS=OLD_IFS

CLASSPATH=$JAR_DEPS
echo "CLASSPATH: [$CLASSPATH]" >&2

# Add JavaFX modules to the classpath
# JAVAFX_LIB_PATH=/path/to/javafx-sdk-17/lib
# JAVAFX_MODULES="javafx.controls,javafx.fxml"

echo "Compiling src files..." >&2
echo "$JAVA_FILES" | xargs javac -d ./target/compile/class -cp "$CLASSPATH"

# Check for compilation success
if [ $? -ne 0 ]; then
    echo "Compilation failed." >&2
    exit 1
fi

# Update the build_timestamp
sed -i "s/^build_timestamp=.*/build_timestamp=$(date +%s)000/" ./resource/JP5AppInfo

# Copy Project Resources to class dir in the target folder
cp -rvf ./resource/* "./target/compile/class/rojira/$jp5pkg/" >&2

# Check if the copy was successful
if [ $? -ne 0 ]; then
    echo "Error copying project resources" >&2
    exit 1
fi

echo "Creating jar archive in ./target/compile/class" >&2

cd ./target/compile/class

# echo "jp5pkg [$jp5pkg]"
# echo "version_build [$version_build]"
# echo "JP5Cls [$JP5Cls]"

jar --create --file "../lib/$jp5pkg-${version_build}.jar" --main-class "$JP5_APP_MAIN" $(ls .)

if [ $? -ne 0 ]; then
	echo "Couldn't create $jp5pkg-$version_build.jar file" >&2
	exit 1
fi

cd ../lib/

ln -s "./$jp5pkg-$version_build.jar" "$jp5pkg.jar"

ls -lh * >&2

cd "$APP_DIR"

new_build=$((build+1))

# Update the build number in the file
sed -i "s/^build=.*/build=$new_build/" ./resource/JP5AppInfo

# Update the build_timestamp
sed -i "s/^build_timestamp=.*/build_timestamp=-/" ./resource/JP5AppInfo

echo "Compile OK" >&2

exit 0

# Version: 1.0
# Created: 2024-07-07
