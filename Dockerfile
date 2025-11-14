FROM mcr.microsoft.com/devcontainers/python:3

# Install Node.js 18
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir pytest pyyaml pytest-xdist

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Set up the vscode user as the default
USER vscode

LABEL org.opencontainers.image.source="https://github.com/OBDb/.devcontainer"
LABEL org.opencontainers.image.description="OBDb Development Container with Python, Node.js, and Claude Code pre-installed"
