# Omniscient

A collection of scripts to facilitate distributed resource monitoring. This is a modified version of 
[hamersaw/omniscient](https://github.com/hamersaw/omniscient); credit goes to [Dan Rammer](https://github.com/hamersaw)
for authoring the original version.

The tool uses the [nmon](https://nmon.sourceforge.io/pmwiki.php) binary to capture stats for many different metrics, 
like CPU usage, network usage, disk I/O, etc.

## Installation

### Configuration

Configuration is performed by editing the files in the [etc/](etc) directory. The files in this directory are:

1. [**config.sh**](etc/config.sh): This is a simple bash script used to export and provide easy modification of configuration variables.
   * `NMON_METRICS`: Space-separated list of metrics to capture with `nmon`.
   * `NMON_SNAPSHOTS`: How many snapshots to take of the system before terminating.
   * `SNAPSHOT_SECONDS`: Interval between snapshots (in seconds).
2. [**hosts.txt**](etc/hosts.txt): A file containing cluster host information. Each line is a `hostname log_directory` pair.
   * `log_directory` is the local directory on the machines you're monitoring where you wish to store the monitoring output. 
     A good value for this is `/tmp/omniscient`. These logs will be collected after monitoring is completed and aggregated to 
     a single location for post-processing.

## Usage

### Start Monitor

Launch a monitor by running:

```bash
omni start
```

Starting monitors is performed by remotely SSHing into each node and launching the monitor binaries. Example:

```console
[ccarlson@n01 omniscient]$ ./omni start
n01: Creating log file /home/users/ccarlson/omniscient/ccarlson-20230822-163709.nmon and pidfile /home/users/ccarlson/omniscient/ccarlson-20230822-163709.pid
[+] started monitor with id 'ccarlson-20230822-163709'
```

> *Take note of the monitor id that was generated; you'll need this to stop the monitor.*

### Synopsis

Use `omni help` to view a synopsis:

```console
USAGE omni <COMMAND> [ARGS...]
COMMANDS:
    collect <monitor-id> <directory>    retrieve and compile monitor results.
    help                                display this menu.
    init                                initialize environment DEPRECATED.
    list                                list all monitors.
    remove <monitor-id>                 remove a monitor.
    start                               start a monitor.
    stop <monitor-id>                   stop a monitor.
    cleanup                             clean up omni logs/directories.
    version                             print application version.
```

### Listing Monitors

List running and stopped monitors:

```bash
omni list
```

Example:

```console
[ccarlson@n01 omniscient]$ ./omni list
n01 : ccarlson-20230823-110229 : running : 336922
```

### Stopping Monitor

Stop a running monitor by referencing its monitor id:

```bash
omni stop <monitor_id>
```
Example:

```console
[ccarlson@n01 omniscient]$ ./omni stop ccarlson-20230823-110507
stopping n01
[/] stopped monitor with id 'ccarlson-20230823-110507'
```

> *You can use this to stop a monitor before it has completed all its snapshots.*

## Collecting Monitor Data

After the monitors have been stopped, they will have left `.nmon` output files
in their local directories specified by the `hosts.txt` file. As it stands, these files
are very data rich and need to be processed and aggregated to provide more concise
metrics before we try to analyze them with Python or other tools.

To do this, use:

```bash
omni collect <monitor_id> <output_directory>
```

Example:

```console
[ccarlson@n01 omniscient]$ ./omni collect ccarlson-20230823-110229 $HOME/omniscient/benchmark_1_results
[+] compiled nmon csv files
[+] downloaded host monitor files
[+] combined host monitor files
```

This will create the directory `benchmark_1_results/` with a `.csv` file for
each of the monitors, and an aggregated `.csv` file with all the combined data.

### Remove Monitor

Monitors may be deleted using the `remove` command:

```bash
omni remove <monitor_id>
```

Example:

```console
[ccarlson@n01 omniscient]$ ./omni remove ccarlson-20230823-110229
[-] removed monitor with id 'ccarlson-20230823-110229'
```

Be sure to stop a monitor before it is removed, less 
it will execute indefinitely unless manually stopped.

### Cleanup

To remove all the `.pid`, `.nmon`, and `.nmon.csv` files created by Omniscient in each
of the monitors log directories:

```bash
omni cleanup
```
