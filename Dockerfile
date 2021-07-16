FROM debian:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y vlc \
    vlc-plugin-* \
    xserver-xorg-core \
    xserver-xorg-video-fbdev \
    x11-xserver-utils \
    libgl1-mesa-dri \
    xserver-xorg-video-vesa \
    xautomation \
    feh \
    xauth \
    xinit \
    libasound2-dev \
    alsa-utils \
    unclutter

# disable lxpolkit popup warning
# RUN mv /usr/bin/lxpolkit /usr/bin/lxpolkit.bak

# Set wallpaper
# COPY /conf/desktop-items-0.conf /root/.config/pcmanfm/LXDE-pi/

# Autohide desktop panel
# COPY /conf/panel /root/.config/lxpanel/LXDE-pi/panels/

# Hide desktop panel completely
# COPY /conf/autostart /etc/xdg/lxsession/LXDE-pi/
# COPY /conf/autostart /root/.config/lxsession/LXDE-pi/

# Disable screen from turning it off
COPY /source/etc/X11/xinit/xserverrc /etc/X11/xinit/xserverrc

COPY /source/usr/local/sbin/videogo.sh /usr/local/sbin/videogo.sh

# Enable udevd so that plugged dynamic hardware devices show up in our container.
ENV UDEV 1

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.opencontainers.image.source https://github.com/aperim/docker-vlc-player
LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="Full screen VLC player" \
  org.label-schema.description="Play a stream full screen" \
  org.label-schema.url="https://github.com/aperim/docker-vlc-player" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/aperim/docker-vlc-player" \
  org.label-schema.vendor="Aperim Pty Ltd" \
  org.label-schema.version=$VERSION \
  org.label-schema.schema-version="1.0"


# Install Python modules
# COPY ./requirements/base.txt /code/requirements/base.txt
# COPY ./requirements/prod.txt /code/requirements/prod.txt
# RUN pip3 install -Ur /code/requirements/prod.txt

# COPY . /code/
# WORKDIR /code/

# pi.sh will run when the container starts up on the device
CMD ["/usr/local/sbin/videogo.sh"]
