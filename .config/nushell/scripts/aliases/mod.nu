export use git.nu *
export use docker-compose.nu *

# if $env.TERM_PROGRAM? == "WezTerm" {
    export use wezterm.nu *
# }

# if not (which bat | is-empty) {
    export alias cat = bat -p
# }

export alias vim = nvim
export alias vi = nvim
export alias c = yadm

export alias la = ls -la
export alias ll = ls -l

export alias pn = pnpm

export alias kubectl = minikube kubectl --

export alias trash = rm --trash

export alias lazyyadm = lazygit --git-dir (yadm introspect repo | str trim) --work-tree $nu.home-path

export alias grep = rg

export alias hm = home-manager

