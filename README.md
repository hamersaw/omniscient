# omniscient
## OVERVIEW
A collection of scripts to facilitate distributed resource monitoring.

## INSTALLATION
#### configuration
Configuration is performed by editing the files in the 'etc' directory. The files in this directory are:

1. config.txt: This is a simple bash script used to provide easy modification of some variables. In particular, this script configures nmon and nvidia-smi capture metrics and snapshot intervals.
2. hosts.txt: A file containing cluster host information. Each line is a "ip_address log_directory" pair.
#### initialization
Once configuration is complete the initialization phase is performed using a single command.

    # initialize the system
    ./omin init

This command performs a sequence of events. (1) Attempts to identify the 'nmon' command in the path. If it doesn't exist, it attempts to download a binary for the given distribution. (2) Ensures the 'nvidia-smi' command is available on the system. If not, the initialize step fails. (3) Creates the log directories specified in the configuration on each cluster host.

## USAGE
#### start / stop monitor
Starting and stopping monitors is performed by contacted each node defined in the configuration. Both the nmon and nvidia-smi monitors are handled with a single call.

    # start monitors based on configuration
    ./omni start

    # stop the monitor with id 'rammerd-20200720-214623'
    ./omni stop rammerd-20200720-214623
#### list monitors
Listing all available monitors is performed with this command. The output format is 'host : monitor-id : nmon-status : nvidia-smi-status : nmon-size : nvidia-smi-size'.

    # list all cluster monitors
    ./omni list
#### collect monitors
Analysis over monitor data requires a sequence of manipulation and aggregation. The 'collect' command transforms data to a common format, downloads it to the specified directory, and aggregates values from each cluster host. The results are stored in multiple files:

- \*.nmon.csv: csv formatted nmon output for each individual host 
- \*.nvidia: csv formatted nvidia-smi output for each individual host 
- aggregate.nmon.csv: aggregated nmon csv files

    # collect monitors with id 'rammerd-20200720-214623' 
    #  in the 'data' directory
    ./omni collect rammerd-20200720-214623 data/
#### remove monitor
Monitors may be deleted using the 'remove' command. Be sure to stop a monitor before it is removed, less it will execute indefinitely unless manually stopped.

    # remove monitor with id 'rammerd-20200720-214623'
    ./omni remove rammerd-20200720-214623'

## TIPS
#### ssh public key authentication
TODO

## TODO
- 'collect' - combine nvidia host monitor files
- finish 'TIPS' documentation
- 'remove' - test if monitor is running
