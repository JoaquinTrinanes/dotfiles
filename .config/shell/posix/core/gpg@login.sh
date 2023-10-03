unset SSH_AGENT_PID
SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export SSH_AUTH_SOCK

export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
