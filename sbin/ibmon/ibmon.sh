#!/bin/bash

# This script uses perfquery to monitor IB performance counters:
# https://linux.die.net/man/8/perfquery
# This should be installed when you install the rdma-core package.

[ -z $SNAPSHOT_SECONDS ] && echo "No snapshot interval set in configuration" && exit 1
[ -z $TOTAL_SNAPSHOTS ] && echo "No total snapshots set in configuration" && exit 1

# Check that perfquery is installed
if command -v perfquery > /dev/null; then
  echo "perfquery is installed on the system"
else
  echo "Error: perfquery is not installed on the system. Please install the rdma-core package which includes it."
  exit 1
fi

# Make sure perfquery has adequate privileges
if ! perfquery; then
  echo "Error: Unable to use perfquery; please ensure you're running with root privileges."
  exit 1
fi



