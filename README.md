# OBDb Development Container

Pre-built Docker image for OBDb development with Python, Node.js, and Claude Code.

## What's Included

- Python 3 (from Microsoft's devcontainer base image)
- Node.js 18
- Python packages: pytest, pyyaml, pytest-xdist
- Claude Code CLI (globally installed)

## Usage

Reference this image in your `.devcontainer/devcontainer.json`:

```json
{
  "name": "OBDb Development",
  "image": "ghcr.io/obdb/devcontainer:latest",
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

## Building Locally

```bash
docker build -t obdb-devcontainer .
```

## Publishing

The image is automatically built and published to GitHub Container Registry when changes are pushed to the main branch.
