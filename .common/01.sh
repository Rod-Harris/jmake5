# check are in a rojira-projects-jp5-app directory
if [ ! -e "./resource/JP5AppInfo" ]; then
    echo "You Shall Not Pass: Couldn't find project info file: ./resource/JP5AppInfo" >&2
    exit 1
fi

APP_DIR="$(readlink -f $(pwd))"

# Load values from resource/JP5AppInfo
. ./resource/JP5AppInfo

if [ -z "$jp5pkg" ]; then
	echo "You Shall Not Pass: ./resource/JP5AppInfo didn't contain the required jp5pkg=[Your Project app/pkg] kvp" >&2 
	exit 1
fi
echo "jp5pkg: [$jp5pkg]" >&2

if [ -z "$JP5Cls" ]; then
	echo "You Shall Not Pass: ./resource/JP5AppInfo didn't contain the required JP5Cls=[Your Project Name] kvp" >&2 
	exit 1
fi
echo "JP5Cls: [$JP5Cls]" >&2

if [ -z "$JP5ENV" ]; then
	echo "You Shall Not Pass: ./resource/JP5AppInfo didn't contain the required JP5ENV=[Your Project ENV] kvp" >&2 
	exit 1
fi
echo "JP5ENV: [$JP5ENV]" >&2

if [ -z "$build_timestamp" ]; then
	echo "You Shall Not Pass: ./resource/JP5AppInfo didn't contain the required build_timestamp=[Last Build Timestamp] kvp" >&2 
	exit 1
fi
echo "build_timestamp: [$build_timestamp]" >&2

if [ -z "$build" ]; then
	echo "You Shall Not Pass: ./resource/JP5AppInfo didn't contain the required build=[Next Successful Build Tag Number] kvp" >&2 
	exit 1
fi
echo "build: [$build]" >&2

if [ -z "$version" ]; then
	echo "You Shall Not Pass: ./resource/JP5AppInfo didn't contain the required version=[Target Release] kvp" >&2 
	exit 1
fi
echo "version: [$version]" >&2

if [ -z "$TARGET_DIR_PARENT" ]; then
	echo "You Shall Not Pass: ./resource/JP5AppInfo didn't contain the required TARGET_DIR_PARENT=[/path/to/dir] kvp" >&2 
	exit 1
fi
echo "TARGET_DIR_PARENT: [$TARGET_DIR_PARENT]" >&2

if [ -z "$JP5_APP_MAIN" ]; then
	echo "You Shall Not Pass: ./resource/JP5AppInfo didn't contain the required JP5_APP_MAIN=[pkg.MainClass] kvp" >&2 
	exit 1
fi
echo "JP5_APP_MAIN: [$JP5_APP_MAIN]" >&2

if [ -z "$INSTALL_LIB_DIR" ]; then
	echo "You Shall Not Pass: ./resource/JP5AppInfo didn't contain the required INSTALL_LIB_DIR=[installation directory for created jar libraries] kvp" >&2 
	exit 1
fi
echo "INSTALL_LIB_DIR: [$INSTALL_LIB_DIR]" >&2



