#!/bin/bash

export SNAPSHOT_SECONDS=1  # how often to take a snapshot
export TOTAL_SNAPSHOTS=30  # how many snapshots before exiting

# Metrics

## InfiniBand metrics
export IB_METRICS=""

## nmon metrics
export NMON_METRICS="CPU_ALL:User% CPU_ALL:Sys% DISKBUSY:nvme0n1 DISKREAD:nvme0n1 DISKWRITE:nvme0n1"
