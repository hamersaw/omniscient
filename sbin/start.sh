#!/bin/bash

# check arguments
if [ $# != 0 ]; then
    echo "$usage"
    exit 1
fi

monid="$USER-$(date +%Y%m%d-%H%M%S)"

# iterate over hosts
while read line; do
    # parse host and log directory
    host=$(echo $line | awk '{print $1}')
    directory=$(echo $line | awk '{print $2}')

    logfile="$directory/$monid"

    if [ $host == "127.0.0.1" ]; then
        # start nmon locally
        ($nmoncmd -F $logfile.nmon -c $nmonsnapshots \
            -s $nmonsnapshotseconds -p > $logfile.pid) &
    else
        # start nmon on remote host
        (ssh $remoteusername@$host -n -o ConnectTimeout=500 \
            $nmoncmd -F $logfile.nmon -c $nmonsnapshots \
            -s $nmonsnapshotseconds -p > $logfile.pid) &
    fi
done <$hostfile

# wait for all to complete
wait

echo "[+] started monitor with id '$monid'"
