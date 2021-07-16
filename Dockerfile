FROM bitnami/minideb

RUN install_packages vlc \
    vlc-plugin-* \
    g++ \
    python3-pip \
    python3-setuptools \
    python3-dev \
    build-essential \
    xserver-xorg-core \
    xinit \
    lxsession \
    desktop-file-utils \
    rpd-icons \
    gtk2-engines-clearlookspix \
    matchbox-keyboard \
    libasound2-dev \
    alsa-utils \
    unclutter

# disable lxpolkit popup warning
RUN mv /usr/bin/lxpolkit /usr/bin/lxpolkit.bak

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

# Install Python modules
# COPY ./requirements/base.txt /code/requirements/base.txt
# COPY ./requirements/prod.txt /code/requirements/prod.txt
# RUN pip3 install -Ur /code/requirements/prod.txt

# COPY . /code/
# WORKDIR /code/

# pi.sh will run when the container starts up on the device
CMD ["/usr/local/sbin/videogo.sh"]
