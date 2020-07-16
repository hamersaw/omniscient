#!/bin/bash

version="0.1.0"
usage="usage $(basename $0) <COMMAND> [ARGS...]
COMMANDS:
    help                display this menu.
    init                initialize environment.
    list                list all monitors.
    start               start a monitor.
    stop                stop a monitor.
    version             print application version."

# compute instance variables
basedir="$(dirname $0)"
case $scriptdir in
  /*) 
      export projectdir="$basedir"
      ;;
  *) 
      export projectdir="$(pwd)/$basedir"
      ;;
esac

export scriptdir="$projectdir/sbin"
export hostfile="$projectdir/etc/hosts.txt"

# export commands
if command -v nmon &> /dev/null; then
    export nmoncmd="nmon"
elif [ -f "$projectdir/bin/nmon" ]; then
    export nmoncmd="$projectdir/bin/nmon"
fi

if command -v nvidia-smi &> /dev/null; then
    export nvidiasmicmd="nvidia-smi"
fi

# execute command
case "$1" in
    help)
        echo "$usage"
        ;;
    init)
        $scriptdir/init.sh ${@:2}
        ;;
    list)
        $scriptdir/list.sh ${@:2}
        ;;
    start)
        $scriptdir/start.sh ${@:2}
        ;;
    stop)
        $scriptdir/stop.sh ${@:2}
        ;;
    version)
        echo "v$version"
        ;;
    *)
        echo "$usage"
        exit 1
        ;;
esac
