# Session Manager

A lightweight terminal session manager that simplifies managing multiple tmux sessions, especially useful for remote access via OpenSSH.

## Features

- **Session Management**: View and manage existing tmux sessions with a simple menu interface.
- **Quick Actions**: Use single-key commands to create, delete, or resume sessions.
- **User-Friendly**: Designed for ease of use, even for those unfamiliar with tmux.

## Setup

### Prerequisites
- **zsh**: This session manager is designed to work with zsh. Ensure zsh is installed on your system.
- **tmux**: Required for managing terminal sessions.
- **curl**: Required for downloading the repository.
- **tar**: Required for extracting the downloaded repository.
- **mktemp**: Required for creating temporary directories.

### One-Command Installation (Recommended)
Run the following command to automatically install and configure the session manager:

```sh
sh -c "$(curl -sL https://raw.githubusercontent.com/Aku-n06/session-manager/main/install.sh)"
```

This script:
- Downloads the repository.
- Installs `session-menu.sh` to `~/.session-manager/bin/session-menu`.
- Updates your `.zshrc` file to automatically run the session menu in interactive shells.
- Ensures the menu runs only in interactive shells and not inside tmux.

### Manual Setup
If you prefer to keep the script in this repository, add the following line to your `.zshrc` file:

```sh
~/.cli-dev-tools/sessions-manager/session-menu.sh
```

## Menu

When you run the script, it displays a menu of available tmux sessions along with single-key commands for quick actions. Sessions are stored with a timestamp name (e.g., `YYYYMMDD_HHMMSS`) but are displayed in a user-friendly format.

#### Example Menu:

```text
Available tmux sessions:
1) 27.02.26 23:06
2) work

[n]ew  [d]elete  [r]esume
```

- **`n`**: Create and attach to a new session.
- **`d`**: Delete a session from the numbered list.
- **`r`**: Resume a session from the numbered list.

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

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Support

For questions or issues, please open an issue on the GitHub repository.
