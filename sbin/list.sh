#!/bin/bash

# check arguments
if [ $# != 0 ]; then
    echo "$usage"
    exit 1
fi

export listfmt="%-12s%-30s%-12s%-12s\n"
listdivlen=66

printf "$listfmt" "host" "id" "status" "nmon_size"
printf "%.0s-" $(seq 1 $listdivlen); printf "\n"

# iterate over hosts
while read line; do
    # parse host and log directory
    host=$(echo $line | awk '{print $1}')
    directory=$(echo $line | awk '{print $2}')

    if [ $host == "127.0.0.1" ]; then
        # list local monitors
        find $directory -name "*pid" \
            -exec bash $scriptdir/format.sh "$host" {} \;
    else
        echo "TODO - list on remote node"
        # start application on remote host
    fi
done <$hostfile
