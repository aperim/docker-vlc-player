FROM debian:latest

# Defaults, can be changed at build time
ARG LANG=en_US.UTF-8

ENV LANG $LANG
RUN locale-gen $LANG \
	&& update-locale LANG=$LANG

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    vlc \
    vlc-plugin-* \
    xz-utils \
    unzip \
    avahi-utils \
    dbus \
	xserver-xorg-core \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    libglu1-mesa \
    xfonts-base \
	x11-session-utils \
    x11-utils \
    x11-xfs-utils \
    x11-xserver-utils \
    xauth \
    x11-common \
    libasound2-dev \
    alsa-utils \
    unclutter && \
    ln -s /usr/bin/Xorg /usr/bin/X && \
    rm -rf /var/lib/apt/lists/*

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
# COPY /source/etc/X11/xinit/xserverrc /etc/X11/xinit/xserverrc

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
