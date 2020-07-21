#!/bin/bash

# check arguments
if [ $# != 0 ]; then
    echo "$usage"
    exit 1
fi

# iterate over hosts
while read line; do
    # parse host and log directory
    host=$(echo $line | awk '{print $1}')
    directory=$(echo $line | awk '{print $2}')

    if [ $host == "127.0.0.1" ]; then
        # list local monitors
        (find $directory -name "*pid" \
            -exec bash $scriptdir/format.sh "$host" {} \;) &
    else
        # list remote monitors
        (ssh $host -n -o ConnectTimeout=500 \
            "find $directory -name \"*pid\" \
                -exec bash $scriptdir/format.sh '$host' {} \;") &
    fi
done <$hostfile

# wait for all to complete
wait
