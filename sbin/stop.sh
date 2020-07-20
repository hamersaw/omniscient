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

    #echo "stopping $host"
    if [ $host == "127.0.0.1" ]; then
        # stop local monitors
        (pkill -F $logfile.pid) &
    else
        # stop remote monitors
        (ssh $remoteusername@$host -n -o ConnectTimeout=500 \
            pkill -F $logfile.pid) &
    fi
done <$hostfile

# wait for all to complete
wait

echo "[/] stopped monitor with id '$1'"
