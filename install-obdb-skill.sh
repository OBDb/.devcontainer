#!/bin/bash
# Script to fetch and install the obdb-editor skill

set -e

SKILL_DIR=".claude/skills/obdb-editor"
SKILL_URL="https://github.com/OBDb/.claude-skills/releases/download/latest/obdb-editor.zip"
TEMP_ZIP="/tmp/obdb-editor.zip"

echo "Checking for obdb-editor skill updates..."

# Create the skills directory if it doesn't exist
mkdir -p ".claude/skills"

# Download the latest skill
echo "Downloading latest obdb-editor skill from $SKILL_URL..."
if curl -fsSL "$SKILL_URL" -o "$TEMP_ZIP"; then
    echo "Download successful"

    # Remove existing skill directory if it exists
    if [ -d "$SKILL_DIR" ]; then
        echo "Removing existing skill installation..."
        rm -rf "$SKILL_DIR"
    fi

    # Create the skill directory
    mkdir -p "$SKILL_DIR"

    # Extract the new skill
    echo "Extracting skill to $SKILL_DIR..."
    unzip -o -q "$TEMP_ZIP" -d "$SKILL_DIR"

    # Clean up
    rm "$TEMP_ZIP"

    echo "obdb-editor skill installed successfully!"
else
    echo "Failed to download skill. Skipping installation."
    exit 0
fi
