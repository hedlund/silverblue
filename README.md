# Fedora Silverblue OCI Image

My [Fedora Silverblue](https://silverblue.fedoraproject.org/) customization image.

This is *heavily* inspired by [Jorge Castro](https://www.ypsidanger.com/)'s
articles and videos on the subject, specifically his [uBlue base](https://github.com/ublue-os/base)
image. More inspiration can also be gathered from the
[awesome list](https://github.com/ublue-os/awesome-custom-images) of other
OStree native container images.

There are two main differences from the uBlue base image:

1. Firefox is kept in the Silverblue host system, since I am reliant on U2F
   devices (i.e. Yubikeys), and I haven't found any way of getting them to work
   with flatpak (no, the [all devices](https://github.com/xhorak/firefox-devedition-flatpak/issues/51#issuecomment-345967459)
   override does not work).
2. The service to automatically update flatpaks is not installed. The reason for
   this is that upstream permission changes for apps could be silently granted,
   as outlined in [this article](https://privsec.dev/posts/linux/desktop-linux-hardening/#flatpak).

In addition, the list of applications that are installed is changed to suit my
particular tastes, and the scripts are slightly rewritten.

## Usage

1. Download and install [Fedora Silverblue](https://github.com/ublue-os/base).
2. Before using the image, you probably want to pin the working deployment:
   ```sh
   sudo ostree admin pin 0
   ```
   The index `0` refers to the first deployment listed when running `rpm-ostree status`, so your scenario may warrant another index.
3. Double check that pinning worked by running:
   ```sh
   rpm-ostree status
   ```
4. Rebase the OS to this image by running:
   ```sh
    sudo rpm-ostree rebase --experimental ostree-unverified-registry:ghcr.io/hedlund/silverblue:latest
   ```
5. Reboot and enjoy!
6. To revert back:
   ```sh
   sudo rpm-ostree rebase fedora:fedora/37/x86_64/silverblue
   ```

## Links

- https://github.com/ublue-os/ubuntu
- https://www.ypsidanger.com/building-your-own-fedora-silverblue-image/
- https://fedoramagazine.org/how-i-customize-fedora-silverblue-and-fedora-kinoite/
