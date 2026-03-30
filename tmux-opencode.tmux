#!/usr/bin/env bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/helpers.sh"

default_key_bindings_openopencode="a"
tmux_option_open_opencode="@open-opencode"

set_open_opencode_key_bindings () {
	local key_bindings=$(get_tmux_option "$tmux_option_open_opencode" "$default_key_bindings_openopencode")
	local key
	for key in $key_bindings; do
		tmux bind "$key" run "$CURRENT_DIR/scripts/open-opencode.sh"
	done
}

main () {
    set_open_opencode_key_bindings
}

main
