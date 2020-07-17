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
        $nmoncmd -F $logfile.nmon -c $nmonsnapshots \
            -s $nmonsnapshotseconds -p > $logfile.pid
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

echo "[+] started monitor with id '$monid'"
