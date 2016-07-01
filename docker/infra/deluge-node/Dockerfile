# Consept Deluge p2p node for distributing libfuzzerfication corpus directories

FROM debian:testing

# Run updates for the image and clean unneeded packages

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get autoremove -y && apt-get autoclean

# Install deluge daemon and console ui

RUN apt-get install -y deluged deluge-console

# Add the node configuration script and make it executable

ADD ./nodeconfig.sh /opt/scripts/nodeconfig.sh
RUN chmod +x /opt/scripts/nodeconfig.sh
RUN /opt/scripts/nodeconfig.sh

ENTRYPOINT /opt/scripts/nodeconfig.sh
