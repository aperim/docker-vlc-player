#!/usr/bin/env bash

# Allow VLC to run as root
sed -i 's/geteuid/getppid/' /usr/bin/vlc

# Remove the X server lock file so ours starts cleanly
rm /tmp/.X0-lock &>/dev/null || true

# Set the display to use
export DISPLAY=:0

# Set the DBUS address for sending around system messages
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

# Start the desktop manager
echo "STARTING X"
startx -- -nocursor &

# TODO: work out how to detect X has started
sleep 5

# Hide the cursor
unclutter -display :0 -idle 0.1 &

# Start the VLC media player
/usr/bin/cvlc -q --no-osd -L -f --no-video-title-show --x11-display :0 rtp://@234.0.1.255:1234
