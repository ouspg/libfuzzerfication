#!/bin/bash

# This script does the following:
# 1. Configures the Deluge daemon and starts it.
# 2. Gets info about the most current libfuzzerfication sample collection(s)
#    and optionally downloads the file(s) directly from a resource location.
#    (for example a local http/ftp server for a better performance or
#    when there isn't existing seeds)
# 3. Adds the torrent(s) from a magnet link and starts seeding them.

funtion help () {
    echo "Usage nodeconfig.sh [options]"
}

funtion configure () {
    mkdir -p $sampledir
    mkdir -p /srv/deluge/.config/deluge
    echo "$user:$passwd:10" > /srv/deluge/.config/deluge/auth
}

funtion start () {
    systemctl enable deluged.service
    echo "Starting deluge daemon..."
    systemctl start deluged.service
}

funtion getsamples () {
    for sample in samplelist=$(curl $sampleurl/samplelist.txt); do
        curl -O --output $sampledir $sampleurl$sample
}

funtion addtorrent () {

}

funtion error () {
    echo "Invalid options detected!"
    echo ""
    help
}



sampledir=/srv/deluge/samples
sampleurl="http://storage.googleapis.com/libfuzzerfication/samples"
user=admin
passwd=libfuzzerfication

# TODO: implement these options:
# -d | --download | directly download the samples
# -a | --alternative-url | use a url different from the defaultsampleurl
# -u | --user | configure an alternative user name for connecting the daemon
# -p | --password | set a password for the user used for connecting the daemon
# -r | --remote-enable | enable remote connections to the daemon
