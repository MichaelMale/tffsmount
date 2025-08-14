#!/usr/bin/env bash

# Prepare offline installation bundle for tffsmount.
# This script must be run on an internet-connected Ubuntu 24.04.3 machine.
# It downloads required Debian packages and Python wheels so tffsmount can be
# installed without any network access.

set -euo pipefail

BUNDLE_DIR=${1:-tffsmount_offline}

# Create directory layout
mkdir -p "$BUNDLE_DIR/pip" "$BUNDLE_DIR/deb"

# Build wheel for tffsmount itself
python3 -m pip wheel . -w "$BUNDLE_DIR/pip"

# Download pip dependencies
python3 -m pip download \
  --dest "$BUNDLE_DIR/pip" \
  fusepy==3.0.1 \
  kaitaistruct==0.10 \
  crcengine==0.3

# Download apt packages (and their dependencies)
APT_PACKAGES=(fuse python3 python3-venv python3-pip)

sudo apt-get update
# Store downloaded debs in our bundle directory
sudo apt-get install --reinstall --download-only -y "${APT_PACKAGES[@]}" \
  -o Dir::Cache="$(pwd)/$BUNDLE_DIR/apt-cache" \
  -o Dir::Cache::archives="$(pwd)/$BUNDLE_DIR/deb"

# Remove temporary apt cache directory
rm -rf "$BUNDLE_DIR/apt-cache"

echo "Offline bundle created in $BUNDLE_DIR"
echo "Copy the entire $BUNDLE_DIR directory to a USB drive."
read -rp "Press Enter after safely removing the USB to finish." _

