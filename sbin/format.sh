#!/bin/bash

# validate arguments
if [ $# != 2 ]; then
    exit 1
fi

# initialize instance variables
stripped="${2%.*}"
monid=$(basename $stripped)

# format output
pid=$(cat $2)

# check if procss is running
if ps -p $pid > /dev/null; then
    status="running"
else
    status="stopped"
fi

nmonsize=$(stat -c%s "$stripped.nmon")

printf "$listfmt" "$1" "$monid" "$status" "$nmonsize"
