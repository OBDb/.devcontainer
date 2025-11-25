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
COPY register-obdb-mcp.sh /usr/local/bin/register-obdb-mcp.sh
COPY copy-templates.sh /usr/local/bin/copy-templates.sh
COPY format-test-failures.sh /usr/local/bin/format-test-failures.sh
RUN chmod +x /usr/local/bin/install-obdb-skill.sh /usr/local/bin/update-schemas.sh /usr/local/bin/setup-obdb-dev.sh /usr/local/bin/register-obdb-mcp.sh /usr/local/bin/copy-templates.sh /usr/local/bin/format-test-failures.sh

# Copy template directory
RUN apt-get update && apt-get install -y --no-install-recommends rsync && apt-get clean -y && rm -rf /var/lib/apt/lists/*
COPY template /usr/local/share/obdb-devcontainer/template

# Clone and build vscode-obdb MCP server
WORKDIR /tmp
RUN git clone https://github.com/OBDb/vscode-obdb.git \
    && cd vscode-obdb \
    && npm install \
    && npm run compile:mcp \
    && mkdir -p /usr/local/lib/obdb-mcp \
    && cp -r dist /usr/local/lib/obdb-mcp/ \
    && cp package.json /usr/local/lib/obdb-mcp/ \
    && cd /usr/local/lib/obdb-mcp \
    && npm install --production \
    && cd /tmp \
    && rm -rf vscode-obdb

# Create vscode user for compatibility
RUN useradd -m -s /bin/bash vscode
USER vscode
WORKDIR /workspaces

LABEL org.opencontainers.image.source="https://github.com/OBDb/.devcontainer"
LABEL org.opencontainers.image.description="OBDb Development Container with Python, Node.js, and Claude Code pre-installed"
