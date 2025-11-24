# OBDb Development Container

Pre-built Docker image for OBDb development with Python, Node.js, and Claude Code.

## What's Included

- Python 3.13 (slim base image)
- Node.js 22 (LTS)
- Python packages: pytest, pyyaml, pytest-xdist
- Claude Code CLI (globally installed)
- Auto-updating obdb-editor skill (runs on container start)
- OBDb MCP server (auto-registered with Claude Code on container start)

## Usage

Reference this image in your `.devcontainer/devcontainer.json`:

```json
{
  "name": "OBDb Development",
  "image": "ghcr.io/obdb/devcontainer:latest",
  "postAttachCommand": "/usr/local/bin/setup-obdb-dev.sh",
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-python.python",
        "ms-python.vscode-pylance",
        "ClutchEngineering.obdb-tooling",
        "anthropic.claude-code"
      ]
    }
  },
  "remoteUser": "vscode"
}
```

The `postAttachCommand` runs `/usr/local/bin/setup-obdb-dev.sh` which:
- Downloads and installs the latest obdb-editor skill
- Updates or clones the OBDb schemas repository to `tests/schemas`
- Registers the OBDb MCP server with Claude Code for signalset querying

This ensures you always have the most up-to-date tooling, test schemas, and Claude Code integration.

### Individual Scripts

You can also run individual setup scripts manually if needed:

- `/usr/local/bin/install-obdb-skill.sh` - Update obdb-editor skill only
- `/usr/local/bin/update-schemas.sh` - Update test schemas only
- `/usr/local/bin/register-obdb-mcp.sh` - Register OBDb MCP server only
- `/usr/local/bin/setup-obdb-dev.sh` - Run full setup (recommended)

### OBDb MCP Server

The container includes the [vscode-obdb MCP server](https://github.com/OBDb/vscode-obdb) which provides Claude Code with direct access to signalset data. The server is automatically registered during container startup and provides tools for:

- Listing and retrieving signalsets
- Searching signals with filtering
- Getting signal statistics and metadata
- Querying command support matrices
- Validating signalset data

The MCP server is registered with user scope and persists across all workspaces.

## Building Locally

```bash
docker build -t obdb-devcontainer .
```

## Publishing

The image is automatically built and published to GitHub Container Registry when changes are pushed to the main branch.
