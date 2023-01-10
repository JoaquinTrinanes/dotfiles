# Nushell Environment Config File

use ~/.config/nushell/scripts/command.nu

def create_left_prompt [] {
    let path_segment = if (is-admin) {
        $"(ansi red_bold)($env.PWD)"
    } else {
        $"(ansi green_bold)($env.PWD)"
    }

    $path_segment
}

def create_right_prompt [] {
    let time_segment = ([
        (date now | date format '%m/%d/%Y %r')
    ] | str join)

    $time_segment
}

# Use nushell functions to define your right and left prompt
let-env PROMPT_COMMAND = { create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = { create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = { "〉" }
let-env PROMPT_INDICATOR_VI_INSERT = { ": " }
let-env PROMPT_INDICATOR_VI_NORMAL = { "〉" }
let-env PROMPT_MULTILINE_INDICATOR = { "::: " }

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


# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')

def-env path_add [path: string] {
    let-env PATH = ($env.PATH | split row (char esep) | prepend $path)
}

path_add /usr/local/bin


if command exists "brew" {
    # let brew_programs = [asdf python]
    # let brew_paths = ($brew_programs | par-each { |it| brew --prefix $it | str trim | path join "bin" })
    # path_add $brew_paths

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
let-env PNPM_HOME = $"($env.HOME)/.local/share/pnpm"
path_add $env.PNPM_HOME

# rust
path_add "~/.cargo/bin"

let-env THEME = "nord"

let-env LS_COLORS = (vivid generate $env.THEME | str trim)

