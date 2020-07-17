#!/bin/bash

# check arguments
if [ $# != 1 ]; then
    echo "$usage"
    exit 1
fi

# iterate over hosts
while read line; do
    # parse host and log directory
    host=$(echo $line | awk '{print $1}')
    directory=$(echo $line | awk '{print $2}')

    logfile="$directory/$1"

    if [ $host == "127.0.0.1" ]; then
        # list local monitors
        pid="$(cat $logfile.pid)"
        if ps -p $pid > /dev/null; then
            echo "unable to remove running monitor"
            exit 1
        else
            rm $logfile*
        fi
    else
        echo "TODO - list on remote node"
        # start application on remote host
    fi
done <$hostfile

echo "[-] removed monitor with id '$1'"
