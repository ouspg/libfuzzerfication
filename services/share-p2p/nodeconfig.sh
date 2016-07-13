#!/bin/bash

# This script does the following:
# 1. Configures the Deluge daemon and starts it.
# 2. Gets info about the most current libfuzzerfication sample collection(s)
#    and optionally downloads the file(s) directly from a resource location.
#    (for example a local http/ftp server for a better performance or
#    when there isn't existing seeds)
# 3. Adds the torrent(s) from a magnet link and starts seeding them.

function help () {
    echo "Usage nodeconfig.sh [options]"
}

function configure () {
    echo "Starting deluge daemon temporary to populate configuration files..."
    systemctl start deluged.service
    echo "Stopping deluge daemon..."
    systemctl stop deluged.service
    echo "Done"
    mkdir -p $sampledir
    mkdir -p $autoadd_dir
    echo "$user:$passwd:10" > /srv/deluge/.config/deluge/auth
    chown deluge:deluge $autoadd_dir $sampledir
    chmod 700 $autoadd_dir $sampledir
}

function start () {
    systemctl enable deluged.service
    echo "Starting deluge daemon..."
    systemctl start deluged.service
    echo "Done."
}

function error () {
    echo "Invalid options detected!"
    echo ""
    help
}


# TODO: implement these options:
# -d | --download | directly download the samples
# -a | --alternative-url | use a url different from the defaultsampleurl
# -u | --user | configure an alternative user name for connecting the daemon
# -p | --password | set a password for the user used for connecting the daemon
# -r | --remote-enable | enable remote connections to the daemon
