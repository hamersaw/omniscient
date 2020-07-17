#!/bin/bash

usage="usage $(basename $0) <monitor-id>
COMMANDS:
    help            display this menu"

# check arguments
if [ $# == 1 ] && [ "$1" == "help" ]; then
    echo "$usage"
    exit 0
elif [ $# != 1 ]; then
    echo "$usage"
    exit 1
fi

# iterate over hosts
while read line; do
    # parse host and log directory
    host=$(echo $line | awk '{print $1}')
    directory=$(echo $line | awk '{print $2}')

    logfile="$directory/$1"

    #echo "stopping $host"
    if [ $host == "127.0.0.1" ]; then
        # stop local processes
        kill `cat $logfile.pid`
    else
        echo "TODO"
        # stop node on remote host
        #ssh rammerd@$host -n "kill `cat $pidfile`; rm $pidfile"
    fi
done <$hostfile
