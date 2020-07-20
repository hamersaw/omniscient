#!/bin/bash

# ensure nmon is installed
if [ -z "$nmoncmd" ]; then
    echo "TODO - download nmon binary"
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
        (ssh $remoteusername@$host -n -o ConnectTimeout=500 \
           mkdir -p $directory) &
    fi
done <$hostfile

# wait for all to complete
wait
