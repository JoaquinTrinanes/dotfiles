# Nushell Environment Config File

use ~/.config/nushell/scripts/command.nu


# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

def home [path?: string= ""] {
    $env.HOME | path join $path
}

let-env XDG_CONFIG_HOME = home ".config"
let-env EDITOR = "lvim"
let-env VISUAL = "code"

let-env XDG_DATA_HOME = home ".local/share"
let-env XDG_CACHE_HOME = home ".cache"

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

def-env path_add [path: string, --varname (-v): string = "PATH"] {
    let-env $varname = ($env | get $varname | split row (char esep) | prepend $path)
}

path_add /usr/local/bin

# rust
path_add "~/.cargo/bin"

if command exists "brew" {
    let paths = (brew --prefix asdf python | str trim | lines)
    let asdf_path = $paths.0
    let python_path = $paths.1

    path_add ($asdf_path | path join "bin")

    # Access version-less python command
    path_add ($python_path | path join "libexec/bin")
} else {
    path_add "/opt/asdf-vm/bin"
}

# pip-installed binaries
path_add (python -m site --user-base | str trim | path join "bin")

path_add (home ".asdf/shims")

# pnpm
let-env PNPM_HOME = (home ".local/share/pnpm")
path_add $env.PNPM_HOME

# golang
let-env GOPATH = (home "go")
let-env GOBIN = ($env.GOPATH | path join "bin")
path_add $env.GOBIN

if 'flavours' in (vivid themes | lines) {
  let-env LS_COLORS = (vivid generate flavours)
# let-env LS_COLORS = $"(vivid generate flavours | str trim):su=30;41:ow=30;42:st=30;44:"
}

zoxide init nushell --cmd j | save -f ~/.config/nushell/scripts/plugins/zoxide.nu

let-env PROMPT_INDICATOR_VI_NORMAL = ""
let-env PROMPT_INDICATOR_VI_INSERT = ""
starship init nu | save -f ~/.config/nushell/scripts/plugins/starship.nu

let-env LESS = "-i -R -F"
