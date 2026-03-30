#!/usr/bin/env bash

WINDOW_ID_OPTION="@opencode-window-id"

openOpencode() {
  local ORIGIN_PANE
  ORIGIN_PANE="$(tmux display-message -p "#D")"

  local SESSION_ID
  SESSION_ID="$(tmux display-message -p -t "$ORIGIN_PANE" "#{session_id}")"

  local CURRENT_PATH
  CURRENT_PATH="$(tmux display-message -p -t "$ORIGIN_PANE" "#{pane_current_path}")"

  local WINDOW_ID
  WINDOW_ID="$(tmux show-options -t "$SESSION_ID" -qv "$WINDOW_ID_OPTION")"

  if [ -n "$WINDOW_ID" ] && tmux list-windows -t "$SESSION_ID" -F "#{window_id}" | grep -Fxq "$WINDOW_ID"; then
    tmux select-window -t "$WINDOW_ID"
  else
    WINDOW_ID="$(tmux new-window -P -F "#{window_id}" -n "OpenCode" -c "$CURRENT_PATH" opencode)"
    tmux set-option -t "$SESSION_ID" -q "$WINDOW_ID_OPTION" "$WINDOW_ID"
  fi
}

openOpencode
