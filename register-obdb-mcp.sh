#!/bin/bash
# Script to automatically register the OBDb MCP server with Claude Code

set -e

WORKSPACE_ROOT="${1:-$(pwd)}"
MCP_SERVER_PATH="/usr/local/lib/obdb-mcp/mcp/server.js"

echo "Registering OBDb MCP server for workspace: $WORKSPACE_ROOT"

# Check if already registered
if claude mcp get obdb-signalsets &>/dev/null; then
    echo "OBDb MCP server already registered, skipping..."
    exit 0
fi

# Register the MCP server with user scope (persists across projects)
claude mcp add obdb-signalsets \
    --scope user \
    --command node \
    --arg "$MCP_SERVER_PATH" \
    --arg "$WORKSPACE_ROOT" \
    --env OBDB_WORKSPACE_ROOT="$WORKSPACE_ROOT"

echo "OBDb MCP server registered successfully!"
echo "Available tools: list_signalsets, get_signalset, search_signals, and more"
