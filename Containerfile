ARG FEDORA_MAJOR_VERSION=37
ARG NVIDIA=no

#-------------------------------------------------------------------------------
FROM ghcr.io/cgwalters/fedora-silverblue:${FEDORA_MAJOR_VERSION} AS base
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc
COPY usr /usr
COPY hedlund-firstboot /usr/bin

# When U2F devices and flatpak has been resolved, we can remove Firefox from the
# base image. But until then, it has to stay...
# https://github.com/flatpak/flatpak/issues/4405
# https://github.com/xhorak/firefox-devedition-flatpak/issues/51
#RUN rpm-ostree override remove firefox firefox-langpacks

# Install packages
RUN rpm-ostree install \
  distrobox \
  fira-code-fonts \
  gnome-tweaks \
  podman-compose \
  podman-docker

#-------------------------------------------------------------------------------
FROM base AS nvidia-no

# Nothing to do here, as all is done in the base...

#-------------------------------------------------------------------------------
FROM base AS nvidia-yes
ARG FEDORA_MAJOR_VERSION

# Add RPM Fusion repos and install Nvidia driver
RUN rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${FEDORA_MAJOR_VERSION}.noarch.rpm && \
  rpm-ostree install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${FEDORA_MAJOR_VERSION}.noarch.rpm && \
  rpm-ostree install akmod-nvidia xorg-x11-drv-nvidia && \
  rm -rf /var/log/akmods

# Disable nouveau. This might not be needed in the future:
# https://rpmfusion.org/Howto/NVIDIA#OSTree_.28Silverblue.2FKinoite.2Fetc.29
#RUN rpm-ostree kargs --append=rd.driver.blacklist=nouveau --append=modprobe.blacklist=nouveau --append=nvidia-drm.modeset=1

#-------------------------------------------------------------------------------
FROM nvidia-${NVIDIA} AS final

# Finalize
RUN sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
  systemctl enable rpm-ostreed-automatic.timer && \
  rpm-ostree cleanup -m && \
  ostree container commit
