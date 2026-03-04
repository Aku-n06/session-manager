# Uninstallation Guide

To uninstall the session manager, run the following command:

```sh
sh -c "$(curl -sL https://raw.githubusercontent.com/Aku-n06/session-manager/main/uninstall.sh)"
```

This script:
- Removes the `session-menu` binary from `~/.session-manager/bin`.
- Removes the `.session-manager` directory if it is empty.
- Reverts changes made to your `.zshrc` file.
