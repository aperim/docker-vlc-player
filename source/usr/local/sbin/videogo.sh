#!/usr/bin/env sh

VLC=$(command -v cvlc)

if [ -z "${VLC_SOURCE_URL}" ]; then
    echo "Source URL not defined (VLC_SOURCE_URL)"
    exit 1
fi

if [ -z "${VLC_BITRATE}" ]; then
    VLC_BITRATE=1024
fi

if [ -z "${VLC_CACHE}" ]; then
    VLC_CACHE=1024
fi

if [ -z "${VLC_THREADS}" ]; then
    VLC_THREADS=$(nproc --all)
fi

if [ -z "${VLC_ASPECT_RATIO}" ]; then
    VLC_ASPECT_RATIO=16:9
fi

if [ -z "${VLC_ADAPTIVE_WIDTH}" ]; then
    VLC_ADAPTIVE_WIDTH=1280
fi

if [ -z "${VLC_ADAPTIVE_HEIGHT}" ]; then
    VLC_ADAPTIVE_HEIGHT=720
fi

if [ -z "${VLC_ADAPTIVE_BITRATE}" ]; then
    VLC_ADAPTIVE_BITRATE=2048
fi

if [ -z "${VLC_ADAPTIVE_LOGIC}" ]; then
    VLC_ADAPTIVE_LOGIC=highest
fi

if [ -z "${VLC_VERBOSE}" ]; then
    VLC_VERBOSE=0
fi

if [ -z "${VLC_ZOOM}" ]; then
    VLC_ZOOM=1
fi

if [ -z "${VLC_DISPLAY}" ]; then
    VLC_DISPLAY=:0
fi

if [ -z "${VLC_AVCODEC_OPTIONS}" ]; then
    # VLC_AVCODEC_OPTIONS="--avcodec-dr --avcodec-corrupted --avcodec-hurry-up --avcodec-skip-frame=1 --avcodec-skip-idct=1 --avcodec-fast --avcodec-threads=${VLC_THREADS} --sout-avcodec-strict=-2"
    VLC_AVCODEC_OPTIONS=""
fi

# Allow VLC to run as root
sed -i 's/geteuid/getppid/' /usr/bin/vlc

# Remove the X server lock file so ours starts cleanly
rm /tmp/.X0-lock &>/dev/null || true

# Create XDG_RUNTIME_DIR
mkdir -pv ~/.cache/xdgr
export XDG_RUNTIME_DIR=$PATH:~/.cache/xdgr

# Set the display to use
export DISPLAY=${VLC_DISPLAY}

# Set the DBUS address for sending around system messages
if [ -f "/host/run/dbus/system_bus_socket" ]; then
    export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
fi

# Start the desktop manager
echo "STARTING X"
startx -- -nocursor &

# TODO: work out how to detect X has started
sleep 5

# Hide the cursor
unclutter -display ${DISPLAY} -idle 0.1 &

# Start the VLC media player
# /usr/bin/cvlc -q --no-osd -L -f --no-video-title-show --x11-display ${DISPLAY} --zoom 2 --no-repeat --no-loop --drop-late-frames --skip-frames --play-and-exit rtp://@234.0.1.255:1234 vlc://quit
${VLC} --verbose=${VLC_VERBOSE} --no-disable-screensaver ${VLC_AVCODEC_OPTIONS} --zoom ${VLC_ZOOM} --no-repeat --no-loop --network-caching=${VLC_CACHE} --drop-late-frames --skip-frames --play-and-exit --no-daemon --adaptive-logic="${VLC_ADAPTIVE_LOGIC}" --adaptive-maxwidth=${VLC_ADAPTIVE_WIDTH} --adaptive-maxheight=${VLC_ADAPTIVE_HEIGHT} --adaptive-bw=${VLC_ADAPTIVE_BITRATE} "${VLC_SOURCE_URL}" vlc://quit
