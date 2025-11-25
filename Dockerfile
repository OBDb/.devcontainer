# Start with minimal node image which already has Node.js
FROM node:22-slim

# Install minimal runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    git \
    rsync \
    curl \
    unzip \
    ca-certificates \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Clone schemas repo and install Python dependencies from its requirements.txt
RUN git clone --depth=1 https://github.com/OBDb/.schemas.git /tmp/schemas \
    && pip3 install --no-cache-dir --break-system-packages -r /tmp/schemas/requirements.txt \
    && rm -rf /tmp/schemas

# Install Claude Code globally (unavoidable, but at least no build tools)
RUN npm install -g @anthropic-ai/claude-code && npm cache clean --force

# Clone vscode-obdb and install only runtime deps (skip canvas build by using --ignore-scripts)
RUN git clone https://github.com/OBDb/vscode-obdb.git /tmp/vscode-obdb \
    && cd /tmp/vscode-obdb \
    && npm install --ignore-scripts \
    && npm run compile:mcp \
    && mkdir -p /usr/local/lib/obdb-mcp \
    && cp -r dist /usr/local/lib/obdb-mcp/ \
    && cp package.json /usr/local/lib/obdb-mcp/ \
    && cd /usr/local/lib/obdb-mcp \
    && npm install --omit=dev --ignore-scripts \
    && npm cache clean --force \
    && rm -rf /tmp/vscode-obdb

# Copy setup scripts
COPY install-obdb-skill.sh /usr/local/bin/install-obdb-skill.sh
COPY update-schemas.sh /usr/local/bin/update-schemas.sh
COPY setup-obdb-dev.sh /usr/local/bin/setup-obdb-dev.sh
COPY register-obdb-mcp.sh /usr/local/bin/register-obdb-mcp.sh
COPY copy-templates.sh /usr/local/bin/copy-templates.sh
COPY format-test-results.sh /usr/local/bin/format-test-results.sh
RUN chmod +x /usr/local/bin/install-obdb-skill.sh /usr/local/bin/update-schemas.sh /usr/local/bin/setup-obdb-dev.sh /usr/local/bin/register-obdb-mcp.sh /usr/local/bin/copy-templates.sh /usr/local/bin/format-test-results.sh

# Copy template directory
COPY template /usr/local/share/obdb-devcontainer/template

# Create vscode user for compatibility
RUN useradd -m -s /bin/bash vscode
USER vscode
WORKDIR /workspaces

LABEL org.opencontainers.image.source="https://github.com/OBDb/.devcontainer"
LABEL org.opencontainers.image.description="OBDb Development Container with Python, Node.js, and Claude Code pre-installed"
