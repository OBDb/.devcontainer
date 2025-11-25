#!/bin/bash
# Script to update or clone the OBDb schemas repository

set -e

SCHEMAS_DIR="tests/schemas"

echo "Updating OBDb schemas..."

if [ -d "$SCHEMAS_DIR/.git" ]; then
    echo "Schemas repository exists, pulling latest changes..."
    cd "$SCHEMAS_DIR" && git pull && cd ../..
else
    echo "Cloning schemas repository..."
    # Ensure parent directory exists
    mkdir -p "$(dirname "$SCHEMAS_DIR")"
    git clone --depth=1 https://github.com/OBDb/.schemas.git "$SCHEMAS_DIR"
fi

echo "OBDb schemas updated successfully!"
