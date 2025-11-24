#!/bin/bash
# Script to copy template files into the workspace

set -e

TEMPLATE_DIR="/usr/local/share/obdb-devcontainer/template"
WORKSPACE_ROOT="${1:-$(pwd)}"

echo "Copying template files to workspace: $WORKSPACE_ROOT"

# Check if template directory exists
if [ ! -d "$TEMPLATE_DIR" ]; then
    echo "Warning: Template directory not found at $TEMPLATE_DIR"
    exit 0
fi

# Copy all files from template directory to workspace, creating directories as needed
# Use rsync to preserve structure and only copy if newer
if command -v rsync &> /dev/null; then
    rsync -av --ignore-existing "$TEMPLATE_DIR/" "$WORKSPACE_ROOT/"
    echo "Template files copied successfully using rsync"
else
    # Fallback to cp if rsync not available
    cp -rn "$TEMPLATE_DIR/"* "$WORKSPACE_ROOT/" 2>/dev/null || true
    echo "Template files copied successfully using cp"
fi

echo "Template files are in place"
