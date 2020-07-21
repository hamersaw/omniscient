#!/bin/bash

# check arguments
if [ $# != 2 ]; then
    echo "$usage"
    exit 1
fi

# if doesn't exist -> create destination directory
if [ ! -d "$2" ]; then
    mkdir -p "$2"
fi

metricsopts=""
array=($nmonmetrics)
for metric in "${array[@]}"; do
    metricsopts="$metricsopts -m $metric"
done

# iterate over hosts
while read line; do
    # parse host and log directory
    host=$(echo $line | awk '{print $1}')
    directory=$(echo $line | awk '{print $2}')

    logfile="$directory/$1"

    if [ $host == "127.0.0.1" ]; then
        # convert local nmon to csv
        ([ ! -f "$logfile.nmon.csv" ] && \
            python3 $scriptdir/nmon2csv.py $logfile.nmon $metricsopts \
                > $logfile.nmon.csv) &
    else
        # convert remote nmon to csv
        (ssh $remoteusername@$host -n -o ConnectTimeout=500 \
            "[ ! -f \"$logfile.nmon.csv\" ] && \
                python3 $scriptdir/nmon2csv.py $logfile.nmon $metricsopts \
                    > $logfile.nmon.csv") &
    fi
done <$hostfile

# wait for all to complete
wait

echo "[+] compiled nmon csv files"

# iterate over hosts
nodeid=0
while read line; do
    # parse host and log directory
    host=$(echo $line | awk '{print $1}')
    directory=$(echo $line | awk '{print $2}')

    logfile="$directory/$1"

    if [ $host == "127.0.0.1" ]; then
        # copy local data to collect directory
        cp $logfile.nmon.csv $2/$nodeid-$host.nmon.csv
        cp $logfile.nvidia $2/$nodeid-$host.nvidia
    else
        # copy remote data to collect directory
        scp $remoteusername@$host:$logfile.nmon.csv $2/$nodeid-$host.nmon.csv
        scp $remoteusername@$host:$logfile.nvidia $2/$nodeid-$host.nvidia
    fi

    nodeid=$(( nodeid + 1 ))
done <$hostfile

echo "[+] downloaded host monitor files"

# TODO - combine host monitor files
