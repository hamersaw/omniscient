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
        # remove local monitors
        (rm $logfile*) &
    else
        # remove remote monitors
        (ssh $host -n -o ConnectTimeout=500 \
            rm $logfile*) &
    fi
done <$hostfile

# wait for all to complete
wait

echo "[-] removed monitor with id '$1'"
