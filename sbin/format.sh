#!/bin/bash

# validate arguments
if [ $# != 2 ]; then
    exit 1
fi

# initialize instance variables

basename=$(basename $2)
monid="${basename%.*}"

# format output
pid=$(cat $2)

# check if procss is running
if ps -p $pid > /dev/null; then
    status="running"
else
    status="stopped"
fi

printf "$listfmt" "$1" "$monid" "$status"
