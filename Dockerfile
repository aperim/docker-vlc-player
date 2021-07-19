FROM debian:latest

# Defaults, can be changed at build time
ARG LANG=en_US.UTF-8

ENV LANG $LANG
ENV LC_ALL $LANG
ENV LANGUAGE $LANG

HEALTHCHECK \
    --interval=1m \
    --timeout=3s \
    --start-period=30s \
    --retries=3 \
    CMD pidof vlc > /dev/null || exit 1

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i "/${LANG}/s/^# //g" /etc/locale.gen && \
    locale-gen $LANG \
	&& update-locale LANG=$LANG

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    alsa-utils \
    avahi-utils \
    dbus \
    libasound2-dev \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libglu1-mesa \
    libgtk-3-0 \
    libnss3 \
    locales \
    unclutter \
    unzip \
    vlc \
    vlc-plugin-* \
    x11-common \
    x11-session-utils \
    x11-utils \
    x11-xfs-utils \
    x11-xserver-utils \
    xauth \
    xfonts-base \
    xserver-xorg-input-all \
    xserver-xorg-core \
    xorg \
    xz-utils 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y xserver-xorg-video-*

RUN rm -rf /var/lib/apt/lists/*

COPY /source/usr/local/sbin/videogo.sh /usr/local/sbin/videogo.sh
COPY /source/usr/share/X11/xorg.conf.d/screen-resolution.conf /usr/share/X11/xorg.conf.d/screen-resolution.conf
COPY /source/etc/X11/xorg.conf.d/screen-resolution.conf /etc/X11/xorg.conf.d/screen-resolution.conf

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

CMD ["/usr/local/sbin/videogo.sh"]
