# OBDb Development Container

Pre-built Docker image for OBDb development with Python, Node.js, and Claude Code.

## What's Included

- Python 3.13 (slim base image)
- Node.js 22 (LTS)
- Python packages: pytest, pyyaml, pytest-xdist
- Claude Code CLI (globally installed)
- Auto-updating obdb-editor skill (runs on container start)

## Usage

Reference this image in your `.devcontainer/devcontainer.json`:

```json
{
  "name": "OBDb Development",
  "image": "ghcr.io/obdb/devcontainer:latest",
  "postStartCommand": "/usr/local/bin/install-obdb-skill.sh",
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

The `postStartCommand` automatically downloads and installs the latest obdb-editor skill every time the container starts, ensuring you always have the most up-to-date tooling.

## Building Locally

```bash
docker build -t obdb-devcontainer .
```

## Publishing

The image is automatically built and published to GitHub Container Registry when changes are pushed to the main branch.
