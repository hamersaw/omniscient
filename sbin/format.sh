#!/bin/bash

# validate arguments
if [ $# != 2 ]; then
    exit 1
fi

# initialize instance variables
stripped="${2%.*}"
monid=$(basename $stripped)

# check if procss is running
pid=$(cat $2)
if ps -p $pid > /dev/null; then
    status="running"
else
    status="stopped"
fi

# retrieve file sizes
nmonsize=$(stat -c%s "$stripped.nmon")

printf "$listfmt" "$1" "$monid" "$status" "$nmonsize"
