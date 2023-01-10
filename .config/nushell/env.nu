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

def home [path: string] {
    $env.HOME | path join $path
}

let-env XDG_CONFIG_HOME = home ".config"
let-env EDITOR = "nvim"
let-env VISUAL = "code"

let-env XDG_DATA_HOME = home ".local/share"
let-env XDG_CACHE_HOME = home ".cache"

# let-env NVIM_HOME = $env.XDG_CONFIG_HOME | path join "nvim"


# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
let-env THEME = "nord"

load-env {
    PNPM_HOME: (home ".local/share/pnpm")
    LS_COLORS: $"(vivid generate $env.THEME | str trim):su=30;41:ow=30;42:st=30;44:"
}

def-env path_add [path: string] {
    let-env PATH = ($env.PATH | split row (char esep) | prepend $path)
}

path_add /usr/local/bin

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

path_add "~/.asdf/shims"

# pnpm
path_add $env.PNPM_HOME

# rust
path_add "~/.cargo/bin"

