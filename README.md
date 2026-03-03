# session manager

This is a small session manager for the terminal; managing multiple sessions that can be
accessed remotely through OpenSSH, leveraging tmux.

Or in simple words, a pretty wrapper around tmux.

This script is most useful when wired into your shell startup (for example, a small
function in `.zshrc`, `.zprofile`, `.bashrc`, or `.bash_profile`). That way, every new
terminal automatically shows the menu, making it easy to pick up an existing session you
started elsewhere (for example, from a mobile device over OpenSSH).

It works with any POSIX-compatible shell; the script itself is `sh`, so the same setup
applies across shells.

If you want this fully automated, run the setup script. It installs the menu to
`~/.session-manager/bin` and updates your detected shell config so the menu appears when
a new interactive shell starts.

If you prefer to keep it in this repo, call `~/.cli-dev-tools/sessions-manager/session-menu.sh`
directly from your shell startup instead.

### Features

Every time you execute the main script; a list of existing sessions is shown to the user,
who can then select one of the existing tmux sessions to attach to, or start a new one.
The menu uses single-key commands for create, delete, and resume.

### Setup

```sh
./setup.sh
```

What it does:

- Installs `session-menu.sh` as `~/.session-manager/bin/session-menu`.
- Detects your login shell and updates the appropriate config file.
- Ensures the menu runs only in interactive shells and not inside tmux.

### Menu

When you run the script, it prints a menu of available tmux sessions, plus a one-key
command line for actions. Sessions created by this script are stored with a safe timestamp
name like `YYYYMMDD_HHMMSS`, but the menu displays them in Swiss format.

Why this menu format: the script reads a single key for input, which keeps the UI
responsive without requiring Enter and matches the current interaction model.

The menu uses single-key commands:

```text
Available tmux sessions:
1) 27.02.26 23:06
2) work

[n]ew  [d]elete  [r]esume
```

Press `n` to create and attach to a new session, `d` to delete a session from a
numbered list, or `r` to resume a session from a numbered list.

### Loop on exit

To show the menu again after you exit or detach from tmux, run the script with a loop
flag from your shell startup:

```sh
SESSION_MENU_LOOP=1 ~/.cli-dev-tools/sessions-manager/session-menu.sh
```

When tmux ends, the script re-runs itself and shows the menu again.

You can disable it for a single shell session with:

```sh
export SESSION_MENU_DISABLE=1
```
# session-manager
