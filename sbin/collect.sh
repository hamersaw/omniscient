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
        # copy data to collect directory
        scp $remoteusername@$host $logfile.nmon $2/$nodeid-$host.nmon
    fi

    nodeid=$(( nodeid + 1 ))
done <$hostfile

echo "[+] downloaded host monitor files"

# convert nmon files to csv
metricsopts=""
array=($nmonmetrics)
for metric in "${array[@]}"; do
    metricsopts="$metricsopts -m $metric"
done

for file in $(find $2 -name "*nmon"); do
    outfile="${file%.*}.csv"
    
    python3 $scriptdir/nmon2csv.py $file $metricsopts > $outfile
done

echo "[+] compiled nmon csv metrics"
