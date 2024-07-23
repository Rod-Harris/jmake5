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
# This run starts here
#

echo "Creating New Run.." >&2

# Create target directory
DS=$(date +%F)
echo "DS: [$DS]" >&2

TS=$(date +%H:%M:%S)
echo "TS: [$TS]" >&2

DTS="[$DS]-[$TS]"
echo "DTS: $DTS" >&2

version_build=$(printf "$version.%03d" $build)
echo "version_build: [$version_build]" >&2

target_run_dir="$TARGET_DIR_PARENT/$DTS-[$version_build]-[Run]"
echo "target_run_dir: $target_run_dir" >&2

mkdir -p "$target_run_dir"
mkdir -p target

if [ -e ./target/run ]; then
    echo "Unlinking old run directory" >&2
    unlink ./target/run
fi

ln -s "$target_run_dir" ./target/run

mkdir -p ./target/run/lib

cp "./target/compile/lib/$jp5pkg-$version_build.jar" ./target/run/

CLASSPATH=""
echo "Checking java dependencies..." >&2
echo "JAR_DEPS: [$JAR_DEPS]" >&2
OLD_IFS=IFS
IFS=':' read -ra jars <<< "$JAR_DEPS"
for jar in "${jars[@]}"; do
    echo "Checking [$jar]" >&2
    if [ ! -f "$jar" ]; then
		echo "You Shall Not Pass: Jar Dependency Not Found: [$jar]" >&2
		exit 1
    fi
    cp -Lv "$jar" ./target/run/lib/ >&2
    
    CLASSPATH="$CLASSPATH:./lib/$(basename $jar)"
done
IFS=OLD_IFS

echo "Checking native dependencies..." >&2
echo "NATIVE_DEPS: [$NATIVE_DEPS]" >&2
OLD_IFS=IFS
IFS=':' read -ra sos <<< "$NATIVE_DEPS"
for so in "${sos[@]}"; do
    echo "Checking [$so]" >&2
    if [ ! -f "$so" ]; then
		echo "You Shall Not Pass: Native Dependency Not Found: [$so]" >&2
		exit 1
    fi
    cp -Lv "$so" ./target/run/lib/ >&2
done
IFS=OLD_IFS

if [ -d ./conf ]; then
	cp -rLv ./conf ./target/run/ >&2
fi

cd ./target/run/

tree >&2

echo "TODO: Modules (JavaFX)" >&2

# Add JavaFX modules to the classpath
# JAVAFX_LIB_PATH=/path/to/javafx-sdk-17/lib
# JAVAFX_MODULES="javafx.controls,javafx.fxml"

# Run Application
if [ -n "$CLASSPATH" ]; then
	#javac $javafx_modules -d ./target/compile/class -cp "$CLASSPATH" $JAVA_FILES
	
	echo "#!/bin/sh" > $jp5pkg.sh
	
	echo "export LD_LIBRARY_PATH=\"$LD_LIBRARY_PATH:./lib\"" >> $jp5pkg.sh
	
	echo "java -cp \"$CLASSPATH:$jp5pkg-$version_build.jar\" \"$JP5_APP_MAIN\" \"\$@\"" >> $jp5pkg.sh
	
	echo "exit $?" >> $jp5pkg.sh
	
	chmod 755 $jp5pkg.sh
	
	export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:./lib"
	
	java -cp "$CLASSPATH:$jp5pkg-$version_build.jar" "$JP5_APP_MAIN" "$@"
else
	echo "java -cp \"$jp5pkg-$version_build.jar\" \"$JP5_APP_MAIN\" \"\$@\"" >> $jp5pkg.sh
	
	echo "exit $?" >> $jp5pkg.sh
	
	chmod 755 $jp5pkg.sh
	
	java -cp "$jp5pkg-$version_build.jar" "$JP5_APP_MAIN" "$@"
fi

# Check # Run Application success
if [ $? -ne 0 ]; then
    echo "Run Terminated" >&2
    exit 1
else
	echo "Run OK" >&2
fi

exit 0

# Version: 1.0
# Created: 2024-07-07
