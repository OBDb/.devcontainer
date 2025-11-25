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

# Copy all files from template directory to workspace
# This will overwrite workspace files that exist in the template,
# but leave workspace-only files untouched
rsync -av "$TEMPLATE_DIR/" "$WORKSPACE_ROOT/"
echo "Template files copied successfully"

echo "Template files are in place"
