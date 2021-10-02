# VLC Player

A containerised VLC player designed for SBC's to
playback unicast and multicast streams.

Think digital signage.

## Installation

Get the container you need.

### For general use

```bash
docker pull ghcr.io/aperim/vlc-player-linux:latest
```

### For raspberry pi

```bash
docker pull ghcr.io/aperim/vlc-player-rpi:latest
```

## Usage in Docker Compose

```yaml
---
version: "3.9"
services:
  mosaic:
    image: ghcr.io/aperim/vlc-player-rpi:latest
    restart: unless-stopped
    network_mode: host
    mem_limit: 1gb
    privileged: true
    environment:
      - VLC_SOURCE_URL=rtp://@234.0.1.255:1234
      - VLC_ZOOM=1.5
    volumes:
      - "/var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket"
    devices:
      - "/dev/tty0:/dev/tty0"
      - "/dev/tty2:/dev/tty2"
      - "/dev/fb0:/dev/fb0"
      - "/dev/input:/dev/input"
      - "/dev/snd:/dev/snd"
```

## Contributing

Pull requests are welcome. For major changes,
please open an issue first to discuss what
you would like to change.

## License

[Apache 2.0](https://choosealicense.com/licenses/apache-2.0/)
