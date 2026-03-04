#!/usr/bin/env sh

# This script uninstalls the session manager by removing the installed files
# and reverting changes made to the .zshrc file.

set -eu

# Define paths
install_dir="$HOME/.session-manager"
config_file="$HOME/.zshrc"

# Remove the installed binary
echo "Removing session manager binary..."
rm -f "$install_dir/bin/session-menu"

# Remove the .session-manager directory if it is empty
if [ -d "$install_dir" ] && [ -z "$(ls -A "$install_dir")" ]; then
  echo "Removing .session-manager directory..."
  rmdir "$install_dir"
fi

# Revert changes in .zshrc
if [ -f "$config_file" ] || [ -L "$config_file" ]; then
  echo "Reverting changes in .zshrc..."
  # Remove the session-manager block from .zshrc
  # Use a temporary file for compatibility with macOS
  tmp_file=$(mktemp)
  if sed '/# session-manager (auto)/,/# end session-manager/d' "$config_file" > "$tmp_file"; then
    mv "$tmp_file" "$config_file"
    echo "Changes reverted in .zshrc."
  else
    echo "Error: Failed to revert changes in .zshrc."
    rm -f "$tmp_file"
  fi
else
  echo "Warning: .zshrc not found. No changes were reverted."
fi

echo "Uninstallation complete!"