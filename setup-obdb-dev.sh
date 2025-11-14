#!/bin/bash
# Meta-script to set up OBDb development environment

set -e

echo "=== Setting up OBDb development environment ==="
echo ""

# Install/update obdb-editor skill
if [ -x "/usr/local/bin/install-obdb-skill.sh" ]; then
    /usr/local/bin/install-obdb-skill.sh
else
    echo "Warning: install-obdb-skill.sh not found, skipping skill installation"
fi

echo ""

# Update schemas
if [ -x "/usr/local/bin/update-schemas.sh" ]; then
    /usr/local/bin/update-schemas.sh
else
    echo "Warning: update-schemas.sh not found, skipping schema update"
fi

echo ""
echo "=== OBDb development environment ready! ==="
