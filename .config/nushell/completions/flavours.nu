def "complete flavours subcommands" [] {
  [
    "apply"
    "build"
    "current"
    "generate"
    "info"
    "list"
    "update"
  ]
}

def "complete flavours themes" [] {
  ^flavours list | str trim | split row " "
}

export extern "flavours" [
  subcommand: string@"complete flavours subcommands"
  --help(-h) # Print help information
  --config(-c): string # Specify a configuration file (Defaults to ~/.config/flavours/config.toml on Linux)
  --directory(-d): string # Specify a data directory (Defaults to ~/.local/share/flavours on Linux)
  --verbose(-v) # Be more verbose
  --version(-V) # Print version information
]

# Applies scheme, according to user configuration
export extern "flavours apply" [
  theme?: string@"complete flavours themes"
  --light(-l) # Skip running heavier hooks (entries marked 'light=false')
  --stdin # Reads scheme from stdin instead of from flavours directory.
]

# Prints last applied scheme name
export extern "flavours current" []

# Shows scheme colors for all schemes matching pattern. Optionally uses truecolor
export extern "flavours info" [
  --raw(-r) #  Don't pretty print the colors.
]

def "complete generate mode" [] {
  [dark light]
}

# Generates a scheme based on an image
export extern "flavours generate" [
  mode: string@"complete generate mode" # Whether to generate a dark or light scheme
  file: string # Which image file to use.
  --slug(-s): string # Scheme slug (the name you specify when applying schemes) to output to. If ommited, defaults to 'generated'
  --name(-n): string # Scheme display name (can include spaces and capitalization) to write, defaults to 'Generated'
  --author(-a): string # Scheme author info (name, email, etc) to write, defaults to 'Flavours'
  --stdout # Outputs scheme to stdout instead of writing it to a file
]
