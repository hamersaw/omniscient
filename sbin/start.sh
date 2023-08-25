#!/bin/bash

# Check arguments
if [ $# != 0 ]; then
  echo "$USAGE"
  exit 1
fi

# Ensure commands are installed
[ -z "$NMON_CMD" ] && echo "nmon not found" && exit 1

# Starts an nmon monitor on a given host
function start_nmon {

  HOST=$1
  DIRECTORY=$2
  NMON_FILE="$DIRECTORY/$MON_ID.nmon"
  NMON_PID_FILE="$DIRECTORY/$MON_ID.nmon.pid"

  if [ "$HOST" == "$(hostname)" ]; then
    # If we're on the current host, run the command locally
    ($NMON_CMD -F $NMON_FILE -c $TOTAL_SNAPSHOTS -s $SNAPSHOT_SECONDS -p >> $NMON_PID_FILE) &
  else
    # Run the command remotely
    (ssh $HOST -n -o ConnectTimeout=500 "$NMON_CMD -F $NMON_FILE -c $TOTAL_SNAPSHOTS -s $SNAPSHOT_SECONDS -p >> $NMON_PID_FILE") &
  fi
}

# Starts an infiniband
function start_ibmon {

  HOST=$1
  DIRECTORY=$2
  IBMON_FILE="$DIRECTORY/$MON_ID.nmon"
  IBMON_PID="$DIRECTORY/$MON_ID.nmon.pid"

  if [ "$HOST" == "$(hostname)" ]; then
    # If we're on the current host, run the command locally
    ($NMON_CMD -F $NMON_FILE -c $TOTAL_SNAPSHOTS -s $SNAPSHOT_SECONDS -p >> $NMON_PID_FILE) &
  else
    # Run the command remotely
    (ssh $HOST -n -o ConnectTimeout=500 "$NMON_CMD -F $NMON_FILE -c $TOTAL_SNAPSHOTS -s $SNAPSHOT_SECONDS -p >> $NMON_PID_FILE") &
  fi
}

MON_ID="$USER-$(date +%Y%m%d-%H%M%S)"

# Iterate over hosts
while read -r LINE; do

  # Parse host and output directory
  HOST=$(echo "$LINE" | awk '{print $1}')
  DIRECTORY=$(echo "$LINE" | awk '{print $2}')

  start_nmon $HOST $DIRECTORY

done < $HOST_FILE

# Wait for all to complete
wait

echo "[+] started monitor with id '$MON_ID'"
