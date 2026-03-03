#!/usr/bin/env sh

if [ -n "$TMUX" ]; then
  exit 0
fi

random_index() {
  awk -v max="$1" 'BEGIN{srand(); print int(rand()*max)}'
}

select_title() {
  if [ -z "$TITLE_INDEX" ]; then
    TITLE_INDEX=$(random_index 9)
  fi
}

title_message() {
  if [ -n "${TITLE_MESSAGE:-}" ]; then
    return
  fi
  if [ -z "${TITLE_MESSAGE_INDEX:-}" ]; then
    TITLE_MESSAGE_INDEX=$(random_index 11)
  fi
  case $TITLE_MESSAGE_INDEX in
    0) TITLE_MESSAGE="HELLO" ;;
    1) TITLE_MESSAGE="HI THERE" ;;
    2) TITLE_MESSAGE="WELCOME" ;;
    3) TITLE_MESSAGE="HEY" ;;
    4) TITLE_MESSAGE="GOOD TO SEE YOU" ;;
    5) TITLE_MESSAGE="GREETINGS" ;;
    6) TITLE_MESSAGE="WELCOME BACK" ;;
    7) TITLE_MESSAGE="NICE TO SEE YOU" ;;
    8) TITLE_MESSAGE="HEY THERE" ;;
    9) TITLE_MESSAGE="GOOD DAY" ;;
    10) TITLE_MESSAGE="HOWDY" ;;
  esac
}

print_title_line() {
  if [ -n "$TITLE_MESSAGE" ]; then
    printf '%s  %s\n' "$1" "$TITLE_MESSAGE"
  else
    printf '%s\n' "$1"
  fi
}

render_title() {
  select_title
  title_message
  case $TITLE_INDEX in
    0)
      printf '%s\n' ' /)_/)' 
      print_title_line '( . .)'
      printf '%s\n' 'c(" )( ")'
      ;;
    1)
      printf '%s\n' " ('>"
      print_title_line ' /))'
      printf '%s\n' ' " "'
      ;;
    2)
      printf '%s\n' '  ___'
      print_title_line " ('v')"
      printf '%s\n' '((   ))'
      ;;
    3)
      printf '%s\n' ' /"\'
      print_title_line '(o o)'
      printf '%s\n' '=^=^='
      ;;
    4)
      printf '%s\n' ' /\_/\'
      print_title_line '( o.o )'
      printf '%s\n' ' > ^ <'
      ;;
    5)
      printf '%s\n' ' /\_/\'
      print_title_line '( -.- )'
      printf '%s\n' '  z z'
      ;;
    6)
      printf '%s\n' ' _._'
      print_title_line '(o,o)'
      printf '%s\n' '|)__)'
      ;;
    7)
      printf '%s\n' '\__/'
      print_title_line '(oo)'
      printf '%s\n' '/||\'
      ;;
    8)
      printf '%s\n' '/^o^\'
      print_title_line '/|_|\'
      printf '%s\n' ' / \'
      ;;
  esac
  printf '\n'
}

if [ "$SESSION_MENU_PREVIEW" = "1" ]; then
  render_title
  exit 0
fi

generate_session_name() {
  timestamp=$(date "+%Y%m%d_%H%M%S")

  printf "%s" "$timestamp"
}

format_session_name() {
  printf "%s\n" "$1" | awk '
    /^[0-9]{8}_[0-9]{6}$/ {
      y=substr($0,1,4)
      m=substr($0,5,2)
      d=substr($0,7,2)
      hh=substr($0,10,2)
      mm=substr($0,12,2)
      ss=substr($0,14,2)
      yy=substr(y,3,2)
      printf "%s.%s.%s %s:%s", d, m, yy, hh, mm
      next
    }
    { print }
  '
}

refresh_sessions() {
  tmux list-sessions -F "#{session_name}" 2>/dev/null
}

find_session_by_name_or_display() {
  printf "%s\n" "$sessions" | awk -v n="$1" '
    function format(name, y,m,d,hh,mm,ss) {
      if (name ~ /^[0-9]{8}_[0-9]{6}$/) {
        y=substr(name,1,4)
        m=substr(name,5,2)
        d=substr(name,7,2)
        hh=substr(name,10,2)
        mm=substr(name,12,2)
        ss=substr(name,14,2)
        yy=substr(y,3,2)
        return d "." m "." yy " " hh ":" mm
      }
      return name
    }
    $0==n {print; exit}
    format($0)==n {print; exit}
  '
}

create_new_session() {
  new_name=$(generate_session_name)
  while tmux has-session -t "$new_name" 2>/dev/null; do
    sleep 1
    new_name=$(generate_session_name)
  done
  printf "Creating new session: %s\n" "$new_name"
  tmux new-session -s "$new_name"
  if [ "${SESSION_MENU_LOOP:-}" = "1" ]; then
    exec "$0"
  fi
  exit 0
}

render_session_list() {
  index=1
  printf "%s\n" "$sessions" | while IFS= read -r session; do
    display=$(format_session_name "$session")
    current_dir_basename=$(tmux display-message -p -t "$session" "#{pane_current_path}")
    current_dir_basename=$(basename "$current_dir_basename")
    printf "\033[1;36m%d)\033[0m %s \033[1;34m%s\033[0m\n" "$index" "$display" "$current_dir_basename"
    index=$((index + 1))
  done
}

print_menu() {
  if command -v tput >/dev/null 2>&1; then
    tput clear
  else
    clear 2>/dev/null
  fi
  render_title
  printf "\033[1;34mAvailable tmux sessions:\033[0m\n"
  render_session_list
  printf "\n\033[1;36m[n]ew  [d]elete  [r]esume\033[0m\n"
}

refresh_and_render_menu() {
  sessions=$(refresh_sessions)
  if [ -z "$sessions" ]; then
    create_new_session
  fi
  printf "\n"
  print_menu
}

delete_session_flow() {
  if command -v tput >/dev/null 2>&1; then
    tput clear
  else
    clear 2>/dev/null
  fi
  render_title
  printf "\033[1;34mWhich session to delete?\033[0m\n"
  render_session_list
  printf "\n"
  printf "\033[1;36mdelete:\033[0m "
  IFS= read -r del_choice
  if [ -z "$del_choice" ]; then
    refresh_and_render_menu
    return
  fi
  case $del_choice in
    *[!0-9]*)
      refresh_and_render_menu
      return
      ;;
    *)
      del_target=$(printf "%s\n" "$sessions" | awk -v n="$del_choice" 'NR==n{print; exit}')
      ;;
  esac
  if [ -z "$del_target" ]; then
    refresh_and_render_menu
    return
  fi
  del_display=$(format_session_name "$del_target")
  tmux kill-session -t "$del_target"
  printf "\033[1;31mDeleted: %s\033[0m\n" "$del_display"
  refresh_and_render_menu
}

resume_session_flow() {
  if command -v tput >/dev/null 2>&1; then
    tput clear
  else
    clear 2>/dev/null
  fi
  render_title
  printf "\033[1;34mWhich session to resume?\033[0m\n"
  render_session_list
  printf "\n"
  printf "\033[1;36mresume:\033[0m "
  IFS= read -r resume_choice
  if [ -z "$resume_choice" ]; then
    refresh_and_render_menu
    return
  fi
  case $resume_choice in
    *[!0-9]*)
      refresh_and_render_menu
      return
      ;;
    *)
      selected=$(printf "%s\n" "$sessions" | awk -v n="$resume_choice" 'NR==n{print; exit}')
      if [ -z "$selected" ]; then
        refresh_and_render_menu
      fi
      ;;
  esac
}

sessions=$(refresh_sessions)

if [ -z "$sessions" ]; then
  new_name=$(generate_session_name)
  printf "No tmux sessions found. Creating: %s\n" "$new_name"
  tmux new-session -s "$new_name"
  if [ "${SESSION_MENU_LOOP:-}" = "1" ]; then
    exec "$0"
  fi
  exit 0
fi

print_menu

selected=""
while [ -z "$selected" ]; do
  IFS= read -r -n 1 key
  if [ -z "$key" ]; then
    printf "\nInvalid selection. Please enter a number or name.\n"
    continue
  fi

  case $key in
    n|N)
      create_new_session
      ;;
    d|D)
      delete_session_flow
      continue
      ;;
    r|R)
      resume_session_flow
      ;;
    *)
      refresh_and_render_menu
      continue
      ;;
  esac
done

tmux attach-session -t "$selected"
if [ "${SESSION_MENU_LOOP:-}" = "1" ]; then
  exec "$0"
fi
