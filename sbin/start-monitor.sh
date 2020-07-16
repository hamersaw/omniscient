#!/bin/bash

# check arguments
if [ $# != 0 ]; then
    echo "usage: $(basename $0)"
    exit
fi

# compute instance variables
scriptdir="$(dirname $0)"
case $scriptdir in
  /*) 
      projectdir="$scriptdir/.."
      ;;
  *) 
      projectdir="$(pwd)/$scriptdir/.."
      ;;
esac

hostfile="$projectdir/etc/hosts.txt"

# set nmon command
if command -v nmon &> /dev/null; then
    nmon="nmon"
elif [ -f "$projectdir/bin/nmon" ]; then
    nmon="$projectdir/bin/nmon"
else
    echo "echo 'nmon' not found"
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
        $nmon -F $logfile.nmon -c 3600 -s 10 -p > $logfile.pid
    else
        echo "TODO - start on remote node"
        # start application on remote host
    #    ssh rammerd@$host -n "RUST_LOG=debug,h2=info,hyper=info,tower_buffer=info \
    #        $application $nodeid -i $host -p $gossipport \
    #        -r $rpcport -x $xferport $options \
    #            > $projectdir/log/node-$nodeid.log 2>&1 & \
    #        echo \$! > $projectdir/log/node-$nodeid.pid"

        #(OUTPUT=$(ssh $USERNAME@$HOST -n -o ConnectTimeout=500 $COMMAND 2>&1); \
        #    echo -e "--$HOST--\n$OUTPUT") &
        #done

        # wait for all commands to complete
        #wait
    fi
done <$hostfile

echo "started with monitor id '$monid'"
