#!/bin/bash

usage="usage $(basename $0)
COMMANDS:
    help                    display this menu"

# check arguments
if [ $# == 1 ] && [ "$1" == "help" ]; then
    echo "$usage"
    exit 0
elif [ $# != 0 ]; then
    echo "$usage"
    exit 1
fi

# iterate over hosts
while read line; do
    # parse host and log directory
    host=$(echo $line | awk '{print $1}')
    directory=$(echo $line | awk '{print $2}')

    if [ $host == "127.0.0.1" ]; then
        echo "TODO - list locally"
        # start nmon locally
    else
        echo "TODO - list on remote node"
        # start application on remote host
    fi
done <$hostfile
