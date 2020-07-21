#!/bin/bash

# ensure nmon is installed
if [ -z "$nmoncmd" ]; then
    downloaddir="/tmp"
    nmonversion="16j"

    # find release information
    [ ! -f "/etc/os-release" ] && \
        echo "failed to find '/etc/os-release' file" && exit 1

    . /etc/os-release

    # download archive
    wget http://sourceforge.net/projects/nmon/files/nmon$nmonversion.tar.gz \
        --directory-prefix=$downloaddir

    # extract files
    mkdir "$downloaddir/nmon-extract"
    tar xvf "$downloaddir/nmon$nmonversion.tar.gz" \
        -C "$downloaddir/nmon-extract"

    # move binary
    mkdir $projectdir/bin
    case "$ID:$VERSION_ID" in
        fedora:31)
            mv "$downloaddir/nmon-extract/nmon_x86_rhel75" \
                "$projectdir/bin/nmon"
            ;;
        *)
            echo "unsupported distribution '$ID:$VERSION_ID'"
            exit 1
            ;;
    esac

    # cleanup
    rm -r "$downloaddir/nmon-extract"
    rm "$downloaddir/nmon$nmonversion.tar.gz"
fi

# ensure nvidia-smi is installed
if [ -z "$nvidiasmicmd" ]; then
    echo "nvidia-smi command not found"
    exit 1
fi

# create log directories on each host 
while read line; do
    # parse host and log directory
    host=$(echo $line | awk '{print $1}')
    directory=$(echo $line | awk '{print $2}')

    if [ $host == "127.0.0.1" ]; then
        (mkdir -p $directory) &
    else
        (ssh $host -n -o ConnectTimeout=500 \
           mkdir -p $directory) &
    fi
done <$hostfile

# wait for all to complete
wait
