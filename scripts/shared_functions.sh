# shared functions and constants

tpm_plugins_variable_name="@tpm_plugins"
SHARED_TPM_PATH=""

# sets a "global variable" for the current file
shared_set_tpm_path_constant() {
	SHARED_TPM_PATH=$(tmux show-environment -g TMUX_PLUGIN_MANAGER_PATH | cut -f2 -d=)
}

shared_get_tpm_plugins_list() {
	tmux show-option -gqv "$tpm_plugins_variable_name"
}

# Allowed plugin name formats:
# 1. "git://github.com/user/plugin_name.git"
# 2. "user/plugin_name"
shared_plugin_name() {
	local plugin=$1
	# get only the part after the last slash, e.g. "plugin_name.git"
	local plugin_basename=$(basename "$plugin")
	# remove ".git" extension (if it exists) to get only "plugin_name"
	local plugin_name=${plugin_basename%.git}
	echo $plugin_name
}

shared_plugin_path() {
	local plugin=$1
	local plugin_name=$(shared_plugin_name "$plugin")
	echo "$SHARED_TPM_PATH$plugin_name/"
}

# TMUX messaging is weird. You only get a nice clean pane if you do it with
# `run-shell` command.
echo_message() {
	local message="$1"
	tmux run-shell "echo '$message'"
}

reload_tmux_environment() {
	tmux source-file ~/.tmux.conf >/dev/null 2>&1
}

plugin_already_installed() {
	local plugin=$1
	local plugin_path=$(shared_plugin_path "$plugin")
	cd $plugin_path &&
		git remote >/dev/null 2>&1
}
