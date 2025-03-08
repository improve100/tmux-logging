#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/shared.sh"

main() {
	if supported_tmux_version_ok; then
		# local file=$(expand_tmux_format_path "${save_complete_history_full_filename}")
		local timestamp=$(date +"%Y%m%dT%H%M%S")
		local file=$(expand_tmux_format_path "${save_complete_history_path}/tmux-history-${timestamp}.log")
		local history_limit="$(tmux display-message -p -F "#{history_limit}")"
		for _window in $(tmux list-windows -F '#I'); do
			for _pane in $(tmux list-panes -t ${_window} -F '#P'); do
				echo "++++++tmux-history-window:${_window}-pane:${_pane}++++++" >> "${file}"
				tmux capture-pane -J -S "-${history_limit}" -p -t "${_window}.${_pane}" >> "${file}"
				display_message "History saved to ${file}"
			done
		done
	fi
}
main
