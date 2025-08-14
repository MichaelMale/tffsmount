#!/usr/bin/env bash

# Install tffsmount and its dependencies from an offline bundle.
# Run this on an air-gapped Ubuntu 24.04.3 system after copying the bundle
# produced by prepare_offline.sh.

set -euo pipefail

BUNDLE_DIR=${1:-tffsmount_offline}

# Install Debian packages
sudo dpkg -i "$BUNDLE_DIR"/deb/*.deb && sudo apt-get -y --no-download -f install

# Create and activate virtual environment
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies and tffsmount from the local wheel cache
pip install --no-index --find-links="$BUNDLE_DIR/pip" \
    fusepy kaitaistruct crcengine tffsmount

deactivate

echo "tffsmount installed. Activate the virtual environment with 'source venv/bin/activate'."

