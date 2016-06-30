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

funtion start () {
    systemctl enable deluged.service
    echo "Starting deluge daemon..."
    systemctl start deluged.service
    echo "Done."
}

funtion getsamples () {
    for sample in $(curl --silent $baseurl/samplelist.txt); do
        echo "Downloading $sample..."
        curl -O --output $sampledir $baseurl$sample
        echo "Done."    
    done
    echo "Downloading samples complete."
}

funtion gettorrents () {
    for torrentfile in $(curl $baseurl/torrentfiles.txt); do
        curl -O --output $autoadd_dir $baseurl$torrentfile
    done
    echo "Getting torrents complete."
}

funtion error () {
    echo "Invalid options detected!"
    echo ""
    help
}



sampledir="/srv/deluge/samples"
autoadd_dir="/srv/deluge/autoadd"
baseurl="http://storage.googleapis.com/libfuzzerfication/samples"
user=admin
passwd=libfuzzerfication

# TODO: implement these options:
# -d | --download | directly download the samples
# -a | --alternative-url | use a url different from the defaultsampleurl
# -u | --user | configure an alternative user name for connecting the daemon
# -p | --password | set a password for the user used for connecting the daemon
# -r | --remote-enable | enable remote connections to the daemon
