#!/bin/bash

# check arguments
if [ $# != 1 ]; then
    echo "usage: $(basename $0) <monitor-id>"
    exit
fi

# compute project directory and hostfile locations
scriptdir="$(dirname $0)"
case $scriptdir in
  /*) 
      projectdir="$scriptdir/.."
      ;;
  *) 
      projectdir="$(pwd)/$scriptdir/.."
      ;;
esac

hostfile="$projectdir/etc/hosts.txt"

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
