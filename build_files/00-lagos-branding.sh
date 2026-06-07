#!/usr/bin/env bash
set -eoux pipefail

IMAGE_INFO="/usr/share/ublue-os/image-info.json"
# We append "-dx" to the image name internally so that Bazzite scripts
# (like bazzite-hardware-setup) do not delete steamos.conf.
if [[ "$IMAGE_NAME" == "lagos" ]]; then
    INTERNAL_IMAGE_NAME="lagos-dx"
elif [[ "$IMAGE_NAME" == "lagos-nvidia" ]]; then
    INTERNAL_IMAGE_NAME="lagos-dx-nvidia"
else
    INTERNAL_IMAGE_NAME="$IMAGE_NAME"
fi

IMAGE_REF="ostree-image-signed:docker://ghcr.io/$IMAGE_VENDOR/$IMAGE_NAME"

# image-info File
if [[ -f "$IMAGE_INFO" ]]; then
    sed -i 's/"image-name": [^,]*/"image-name": "'"$INTERNAL_IMAGE_NAME"'"/' $IMAGE_INFO
    sed -i 's|"image-ref": [^,]*|"image-ref": "'"$IMAGE_REF"'"|' $IMAGE_INFO
    sed -i 's/"image-vendor": [^,]*/"image-vendor": "'"$IMAGE_VENDOR"'"/' $IMAGE_INFO
fi

# OS Release File
if [[ -f /usr/lib/os-release ]]; then
    sed -i 's/Bazzite/LagOS/g' /usr/lib/os-release
    sed -i 's/bazzite/lagos/g' /usr/lib/os-release
    sed -i 's/^ID_LIKE=.*/ID_LIKE="bazzite fedora"/' /usr/lib/os-release
    sed -i "s/^VARIANT_ID=.*/VARIANT_ID=$INTERNAL_IMAGE_NAME/" /usr/lib/os-release
fi

# KDE About page
if [[ -f /etc/xdg/kcm-about-distrorc ]]; then
    sed -i 's/Bazzite/LagOS/g' /etc/xdg/kcm-about-distrorc
fi

