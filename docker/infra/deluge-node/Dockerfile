# Consept Deluge p2p node for distributing libfuzzerfication corpus directories

FROM debian:testing

# Run updates for the image and clean unneeded packages

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get autoremove -y && apt-get autoclean

# Install deluge daemon and console ui

RUN apt-get install -y deluged deluge-console

ADD ./configure-node.sh /opt/tools/configure-node.sh

RUN chmod +x /opt/tools/configure-node.sh
