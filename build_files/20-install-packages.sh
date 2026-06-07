#!/usr/bin/env bash
set -eoux pipefail

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
dnf5 install -y tmux 

# Enable Podman socket service
systemctl enable podman.socket
