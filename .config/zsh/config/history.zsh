HISTFILE="$ZDOTDIR/.history"
SAVEHIST=1000
HISTSIZE=1000

CUSTOM_ZSH_OPTIONS+=(
    append_history
    extended_history
    hist_expire_dups_first
    hist_ignore_space
)
