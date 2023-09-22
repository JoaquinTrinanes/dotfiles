commandExists() {
	command -v "$1" >/dev/null 2>&1
}

alias reload='exec "$XSHELL"' # reload the current shell configuration

alias k9s="k9s --readonly"
alias dots="yadm"
alias c="yadm"

# human readable output
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias df='df -h' du='du -h'

alias vim="nvim"

if commandExists rg; then
	alias grep="rg"
else
	alias grep="grep -E"
fi

if commandExists xdg-open; then
	alias open='nohup xdg-open </dev/null >|$(mktemp --tmpdir nohup.XXXX) 2>&1'
	alias o="open"
fi

if commandExists eza; then
	args=""
	if fc-list | grep "Nerd Font" >/dev/null 2>&1; then
		args="--icons"
	fi
	# shellcheck disable=2139
	alias ls="eza ${args}"
	alias la="ls -la"
	unset args
fi

if commandExists bat; then
	export MANPAGER="sh -c 'col -bx | bat -l man -p'"
	alias cat="bat -p"
fi

if commandExists helix; then
	alias hx="helix"
fi

unset -f commandExists
