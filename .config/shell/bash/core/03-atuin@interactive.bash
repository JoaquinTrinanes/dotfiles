if command -v atuin &> /dev/null; then
    unset HISTFILE
    eval "$(atuin init bash --disable-up-arrow)"
fi
