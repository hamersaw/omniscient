#!/bin/bash

OMNI_DIR="$PROJECT_MANAGEMENT/cluster/monitoring/omniscient"
BIN_DIR="$OMNI_DIR/bin"

# create log directories on each HOST
while read -r LINE; do
    # parse host and log directory
    HOST=$(echo "$LINE" | awk '{print $1}')
    DIRECTORY=$(echo "$LINE" | awk '{print $2}')

    if [ "$HOST" == "$(hostname)" ]; then
        mkdir -p "$DIRECTORY"
        rm -rf "$BIN_DIR" && mkdir "$BIN_DIR"
        # Download archived binary for RHEL 8
        wget https://sourceforge.net/projects/nmon/files/nmon16m_x86_64_rhel8/download --directory-prefix="$BIN_DIR"
        # Rename binary to "nmon"
        mv "$BIN_DIR/nmon16m_x86_64_rhel8" "$BIN_DIR/nmon" && chmod +x "$BIN_DIR/nmon"
    else
        ssh "$HOST" -n -o ConnectTimeout=500 "mkdir -p $DIRECTORY && rm -rf $BIN_DIR && mkdir $BIN_DIR && \
          wget https://sourceforge.net/projects/nmon/files/nmon16m_x86_64_rhel8/download --directory-prefix=$BIN_DIR && \
          mv $BIN_DIR/nmon16m_x86_64_rhel8 $BIN_DIR/nmon && chmod +x $BIN_DIR/nmon"
    fi

    echo "Finished initializing nmon on $HOST"
done < "$HOST_FILE"
