# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

. $HOME/.profile

eval "$(direnv hook bash)"
eval "$(starship init bash)"
