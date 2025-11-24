#!/bin/bash
# Meta-script to set up OBDb development environment

set -e

echo "=== Setting up OBDb development environment ==="
echo ""

# Copy template files to workspace
if [ -x "/usr/local/bin/copy-templates.sh" ]; then
    /usr/local/bin/copy-templates.sh
else
    echo "Warning: copy-templates.sh not found, skipping template copy"
fi

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

# Register OBDb MCP server with Claude Code
if [ -x "/usr/local/bin/register-obdb-mcp.sh" ]; then
    /usr/local/bin/register-obdb-mcp.sh
else
    echo "Warning: register-obdb-mcp.sh not found, skipping MCP registration"
fi

echo ""
echo "=== OBDb development environment ready! ==="
