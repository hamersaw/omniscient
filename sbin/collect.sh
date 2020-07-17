#!/bin/bash

usage="usage $(basename $0) <monitor-id> <dst-directory>
COMMANDS:
    help            display this menu"

# check arguments
if [ $# == 1 ] && [ "$1" == "help" ]; then
    echo "$usage"
    exit 0
elif [ $# != 2 ]; then
    echo "$usage"
    exit 1
fi

# if doens't exist -> create destination directory
if [ ! -d "$2" ]; then
    mkdir -p "$2"
fi

# iterate over hosts
nodeid=0
while read line; do
    # parse host and log directory
    host=$(echo $line | awk '{print $1}')
    directory=$(echo $line | awk '{print $2}')

    logfile="$directory/$1"

    if [ $host == "127.0.0.1" ]; then
        # copy data to collect directory
        cp $logfile.nmon $2/$nodeid-$host.nmon
    else
        echo "TODO - list on remote node"
        # start application on remote host
    fi

    nodeid=$(( nodeid + 1 ))
done <$hostfile

# convert nmon files to csv - TODO parameterize data
for file in $(find $2 -name "*nmon"); do
    outfile="${file%.*}.csv"
    
    python3 $scriptdir/nmon2csv.py $file \
        -m "CPU_ALL:User%" -m "MEM:active" > $outfile
done
