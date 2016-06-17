# Debian Docker image (x86_64 and armhf)

Build a small Debian Docker image with cron and [s6][s6] installed. 

## Build automagical

Use make:

```
git clone -b debian https://github.com/christiansteier/dockerfiles.git
cd dockerfiles/debian-base && sudo make
```

To build you need debootstrap and debian-keyring installed:
 * Debian based systems
   ```
   sudo apt-get install debootstrap debian-keyring
   ```
 * Archlinux based systems
   ```
   yaourt -S debootstrap debian-keyring
   ```

## Usage

On x86 64-bit server:
```dockerfile
FROM maxder/debian-base:x86_64
RUN ...
```

On ARM server like rpi:
```dockerfile
FROM maxder/debian-base:armhf
RUN ...
```

[s6]: http://skarnet.org/software/s6/
