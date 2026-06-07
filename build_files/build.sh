#!/usr/bin/env bash
set -eo pipefail

BUILD_SCRIPTS_PATH="$(realpath "$(dirname "$0")")"

# Run scripts in order
scripts=(
    "00-lagos-branding.sh"
    "20-install-packages.sh"
    "50-fix-opt.sh"
    "99-build-initramfs.sh"
    "999-cleanup.sh"
)

for script in "${scripts[@]}"; do
    script_path="${BUILD_SCRIPTS_PATH}/${script}"
    if [ -f "$script_path" ]; then
        printf "::group:: === %s ===\n" "$script"
        /usr/bin/bash "$script_path"
        printf "::endgroup::\n"
    else
        echo "Script not found: $script_path"
        exit 1
    fi
done
