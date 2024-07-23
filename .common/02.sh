# check the project has been compiled
if [ ! -e "./target/compile/class/rojira/$jp5pkg/JP5AppInfo" ]; then
    echo "You Shall Not Pass: Couldn't find project compile info file: [./target/compile/class/rojira/$jp5pkg/JP5AppInfo]" >&2
    exit 1
fi

. ./target/compile/class/rojira/$jp5pkg/JP5AppInfo

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
