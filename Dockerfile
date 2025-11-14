# Use slim base image instead of full devcontainer
FROM python:3.13-slim

# Install minimal system dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    unzip \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir pytest pyyaml pytest-xdist

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Copy setup scripts
COPY install-obdb-skill.sh /usr/local/bin/install-obdb-skill.sh
COPY update-schemas.sh /usr/local/bin/update-schemas.sh
COPY setup-obdb-dev.sh /usr/local/bin/setup-obdb-dev.sh
RUN chmod +x /usr/local/bin/install-obdb-skill.sh /usr/local/bin/update-schemas.sh /usr/local/bin/setup-obdb-dev.sh

# Create vscode user for compatibility
RUN useradd -m -s /bin/bash vscode
USER vscode

LABEL org.opencontainers.image.source="https://github.com/OBDb/.devcontainer"
LABEL org.opencontainers.image.description="OBDb Development Container with Python, Node.js, and Claude Code pre-installed"
