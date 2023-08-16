if command -v atuin &>/dev/null; then
	unset HISTFILE
	eval "$(atuin init zsh)"
fi
