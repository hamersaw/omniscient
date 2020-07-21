#!/bin/bash

# validate arguments
if [ $# != 2 ]; then
    exit 1
fi

output="$1"

# initialize instance variables
stripped="${2%.*}"
monid=$(basename $stripped)

output="$output : $monid"

# check if processes are running
while read pid; do
    if ps -p $pid > /dev/null; then
        status="running"
    else
        status="stopped"
    fi
        
    output="$output : $status"
done <$2

# retrieve file sizes
nmonsize=$(stat -c%s "$stripped.nmon")
nvidiasmisize=$(stat -c%s "$stripped.nvidia")

output="$output : $nmonsize : $nvidiasmisize"

# print data to stdout
echo "$output"
