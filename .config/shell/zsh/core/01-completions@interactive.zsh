autoload -Uz compinit
compinit

# autocomplete with same color as ls
if command -v dircolors &> /dev/null; then
    eval "$(dircolors)"
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
else
    export CLICOLOR=1
fi

# tab select autocomplete
zstyle ':completion:*' menu select

# case insensitive autocomplete
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# autocomplete . and ..
zstyle ':completion:*' special-dirs true

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
    adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
    clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
    gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
    ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
    named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
    operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
    rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
    usbmux uucp vcsa wwwrun xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

# tabtab source for packages
# uninstall by removing these lines
if [[ -f ${XDG_CONFIG_HOME}/tabtab/zsh/__tabtab.zsh ]]; then
    . "${XDG_CONFIG_HOME}/tabtab/zsh/__tabtab.zsh" || true
fi
