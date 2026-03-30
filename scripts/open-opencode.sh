#!/usr/bin/env bash

WINDOW_ID_OPTION="@opencode-window-id"
WINDOW_POSITION_OPTION="@opencode-window-position"

getWindowTarget() {
  local session_id="$1"
  local requested_position="$2"

  if [ -z "$requested_position" ]; then
    return 0
  fi

  if ! [[ "$requested_position" =~ ^[0-9]+$ ]]; then
    return 0
  fi

  local occupied_positions
  occupied_positions="$(tmux list-windows -t "$session_id" -F "#{window_index}")"

  local target_position
  target_position="$requested_position"

  while printf '%s\n' "$occupied_positions" | grep -Fxq "$target_position"; do
    target_position="$((target_position + 1))"
  done

  printf '%s:%s' "$session_id" "$target_position"
}

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
    local WINDOW_POSITION
    WINDOW_POSITION="$(tmux show-options -gqv "$WINDOW_POSITION_OPTION")"

    local WINDOW_TARGET
    WINDOW_TARGET="$(getWindowTarget "$SESSION_ID" "$WINDOW_POSITION")"

    if [ -n "$WINDOW_TARGET" ]; then
      WINDOW_ID="$(tmux new-window -P -F "#{window_id}" -t "$WINDOW_TARGET" -n "OpenCode" -c "$CURRENT_PATH" opencode)"
    else
      WINDOW_ID="$(tmux new-window -P -F "#{window_id}" -n "OpenCode" -c "$CURRENT_PATH" opencode)"
    fi

    tmux set-option -t "$SESSION_ID" -q "$WINDOW_ID_OPTION" "$WINDOW_ID"
  fi
}

openOpencode
