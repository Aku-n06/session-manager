#!/usr/bin/env sh

set -eu

script_dir=$(cd "$(dirname "$0")" && pwd)
source_script="$script_dir/session-menu.sh"

base_dir="$HOME/.session-manager"
install_dir="$base_dir/bin"
install_path="$install_dir/session-menu"

mkdir -p "$install_dir"
install -m 755 "$source_script" "$install_path"

config_file="$HOME/.zshrc"
block=$(cat <<'EOF'
# session-manager (auto)
if ! echo ":$PATH:" | grep -q ":$HOME/.session-manager/bin:"; then
  export PATH="$HOME/.session-manager/bin:$PATH"
fi

if [ -t 1 ]; then
  if command -v session-menu >/dev/null 2>&1; then
    session-menu
  fi
fi
# end session-manager
EOF
)

if [ -f "$config_file" ] && grep -q "session-manager (auto)" "$config_file"; then
  printf "Setup already present in %s\n" "$config_file"
  printf "Installed to %s\n" "$install_path"
  exit 0
fi

mkdir -p "$(dirname "$config_file")"

{
  printf "\n%s\n" "$block"
} >> "$config_file"

printf "Installed to %s\n" "$install_path"
printf "Updated %s\n" "$config_file"
