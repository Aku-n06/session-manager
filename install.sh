#!/usr/bin/env sh

# This script installs the session manager using curl.
# It downloads the repository, runs the setup script, and cleans up.

set -eu

# Check for prerequisites
check_prerequisites() {
  # Check if curl is installed
  if ! command -v curl >/dev/null 2>&1; then
    echo "Error: curl is required but not installed."
    exit 1
  fi

  # Check if tar is installed
  if ! command -v tar >/dev/null 2>&1; then
    echo "Error: tar is required but not installed."
    exit 1
  fi

  # Check if mktemp is installed
  if ! command -v mktemp >/dev/null 2>&1; then
    echo "Error: mktemp is required but not installed."
    exit 1
  fi

  # Check if tmux is installed
  if ! command -v tmux >/dev/null 2>&1; then
    echo "Error: tmux is required but not installed."
    exit 1
  fi

  # Check if sh is installed
  if ! command -v sh >/dev/null 2>&1; then
    echo "Error: sh is required but not installed."
    exit 1
  fi

  # Check if zsh is installed
  if ! command -v zsh >/dev/null 2>&1; then
    echo "Error: zsh is required but not installed."
    exit 1
  fi
}

# Define the temporary directory for the installation
temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT

# Check prerequisites
check_prerequisites

# Download the repository using curl
echo "Downloading session-manager..."
curl -sL https://github.com/Aku-n06/session-manager/tarball/main | tar -xz -C "$temp_dir" --strip-components=1

# Run the setup script
chmod +x "$temp_dir/setup.sh"
"$temp_dir/setup.sh"

echo "Installation complete!"
