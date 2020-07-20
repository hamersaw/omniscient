#!/bin/bash

# check arguments
if [ $# != 0 ]; then
    echo "$usage"
    exit 1
fi

# ensure commands are installed
[ -z "$nmoncmd" ] && echo "nmon command not found" && exit 1
[ -z "$nvidiasmicmd" ] && echo "nvidia-smi command not found" && exit 1

monid="$USER-$(date +%Y%m%d-%H%M%S)"

array=($nvidiasmimetrics)
for metric in "${array[@]}"; do
	if [ -z "$metricsopts" ]; then
    	metricsopts="$metric"
	else
    	metricsopts="$metricsopts,$metric"
	fi
done

# iterate over hosts
while read line; do
    # parse host and log directory
    host=$(echo $line | awk '{print $1}')
    directory=$(echo $line | awk '{print $2}')

    logfile="$directory/$monid"

    if [ $host == "127.0.0.1" ]; then
        # start local monitors
        ($nmoncmd -F $logfile.nmon -c $nmonsnapshots \
            	-s $snapshotseconds -p >> $logfile.pid; \
            $nvidiasmicmd --query-gpu=$metricsopts --format=csv \
				-l $snapshotseconds >> $logfile.nvidia & 2>&1; \
			echo $! >> $logfile.pid) &
    else
        # start remote monitors
        (ssh $remoteusername@$host -n -o ConnectTimeout=500 \
            "$nmoncmd -F $logfile.nmon -c $nmonsnapshots \
                -s $snapshotseconds -p >> $logfile.pid; \
            $nvidiasmicmd --query-gpu=$metricsopts --format=csv \
				-l $snapshotseconds >> $logfile.nvidia & 2>&1; \
			echo $! >> $logfile.pid") &
    fi
done <$hostfile

# wait for all to complete
wait

echo "[+] started monitor with id '$monid'"
