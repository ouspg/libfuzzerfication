#!/bin/bash

# This script does the following:
# 1. Configures the Deluge daemon and starts it.
# 2. Gets info about the most current libfuzzerfication sample collections
#    and optionally gets them from a local resource location.
# 3. Adds the torrent info from a magnet link and starts seeding them.

funtion help () {


}

funtion configure () {

}

funtion start () {
    systemctl enable deluged.service
    echo "Starting deluge daemon..."
    systemctl start deluged.service
}

funtion getsamples () {

}

funtion addtorrents () {


}
