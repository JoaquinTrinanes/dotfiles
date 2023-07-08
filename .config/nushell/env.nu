# Nushell Environment Config File

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
export-env {
  let esep_list_converter = {
      from_string: { |s| $s | split row (char esep) }
      to_string: { |v| $v | path expand -n | str join (char esep) }
  }

  $env.ENV_CONVERSIONS = {
    "PATH": $esep_list_converter
    "XDG_DATA_DIRS": $esep_list_converter
    "Path": $esep_list_converter
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
$env.NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

def 'path home' [path?: string= ""] {
    $nu.home-path | path join $path
}

export-env {
  load-env {
    PROMPT_INDICATOR_VI_NORMAL: ""
    PROMPT_INDICATOR_VI_INSERT: ""
  }
}

export-env {
  def get_cache [name: string] {
    let cache = ($env.XDG_CACHE_HOME? | default ($nu.home-path | path join '.cache') | path join $name)
    mkdir $cache
    $cache
  }
  let cache_dir = (get_cache "nu")

  # starship
  starship init nu | save -f ($cache_dir | path join "starship.nu")

  # zoxide
  zoxide init nushell --cmd j | save -f ($cache_dir | path join "zoxide.nu")

  # atuin
  atuin init nu --disable-up-arrow | save -f ($cache_dir | path join "atuin.nu")

  load-env {
    NU_LIB_DIRS: ($env.NU_LIB_DIRS? | default [] | append $cache_dir) 
  }
}

# load .env file
if (path home .env.secret | path exists) {
  try {
    open (path home .env.secret) | str trim | lines | split column '=' index value | str trim | reduce -f {} {|x, acc| $acc | merge {$x.index: $x.value}}
  } catch { {} } | load-env
}

