# Setup Guide

## Prerequisites

- **[zsh](https://www.zsh.org/)**: This session manager is designed to work with zsh. Ensure zsh is installed on your system.
- **[tmux](https://github.com/tmux/tmux)**: Required for managing terminal sessions.

## One-Command Installation (Recommended)

Run the following command to automatically install and configure the session manager:

```sh
sh -c "$(curl -sL https://raw.githubusercontent.com/Aku-n06/session-manager/main/install.sh)"
```

This script:
- Downloads the repository.
- Installs `session-menu.sh` to `~/.session-manager/bin/session-menu`.
- Updates your `.zshrc` file to automatically run the session menu in interactive shells.
- Ensures the menu runs only in interactive shells and not inside tmux.

## Manual Setup

If you prefer to keep the script in this repository, add the following line to your `.zshrc` file:

```sh
~/.cli-dev-tools/sessions-manager/session-menu.sh
```

## Loop on Exit

To automatically show the menu again after exiting or detaching from tmux, use the loop flag in your shell startup:

```sh
SESSION_MENU_LOOP=1 ~/.cli-dev-tools/sessions-manager/session-menu.sh
```

This ensures the menu reappears when tmux ends, providing seamless session management.

#### Disabling the Menu

To disable the menu for a single shell session, use:

```sh
export SESSION_MENU_DISABLE=1
```
