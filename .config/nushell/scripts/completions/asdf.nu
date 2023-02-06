def "complete asdf sub-commands" [] {
    [
        "plugin", 
        "list", 
        "install", 
        "uninstall", 
        "current", 
        "where", 
        "which", 
        "local", 
        "global", 
        "shell", 
        "latest",
        "help",
        "exec",
        "env",
        "info",
        "reshim",
        "shim-version",
        "update"
    ]
}

def "complete asdf installed" [] {
    ^asdf plugin list | lines | each { |line| $line | str trim }
}


def "complete asdf plugin sub-commands" [] {
    [
        "list",
        "list all",
        "add",
        "remove",
        "update"
    ]
}

def "complete asdf installed plugins" [] {
    ^asdf plugin list | lines | each { |line|
        $line | str trim
    }
}

# ASDF version manager
export extern "main" [
    subcommand?: string@"complete asdf sub-commands"
]

# Manage plugins
export extern "plugin" [
    subcommand?: string@"complete asdf plugin sub-commands"
]

# List installed plugins
export def "plugin list" [
    --urls # Show urls
    --refs # Show refs
] {

    let params = [
        {name: 'urls', enabled: $urls, template: '\s+?(?P<repository>git@.+\.git)', flag: '--urls'}
        {name: 'refs', enabled: $refs, template: '\s+?(?P<branch>\w+)\s+(?P<ref>\w+)', flag: '--refs'}
    ]

    let template = '(?P<name>.+)' + (
                        $params | 
                        where enabled |
                        get --ignore-errors template |
                        str join '' | 
                        str trim
                    )

    let parsed_urls_flag = ($params | filter {|it| $it.enabled and $it.name == 'urls' } | get --ignore-errors flag | default '' )
    let parsed_refs_flag = ($params |filter {|it| $it.enabled and $it.name == 'refs' } | get --ignore-errors flag | default '' )

    ^asdf plugin list $parsed_urls_flag $parsed_refs_flag | lines | parse -r $template | str trim        
}

# list all available plugins
export def "plugin list all" [] {
    let template = '(?P<name>.+)\s+?(?P<installed>[*]?)(?P<repository>(?:git|http).+\.git)'
    let is_installed = { |it| $it.installed == '*' }

    ^asdf plugin list all | 
        lines | 
        parse -r $template | 
        str trim | 
        update installed $is_installed |
        sort-by name
}

# Add a plugin
export extern  "plugin add" [
    name: string # Name of the plugin 
    git_url?: string # Git url of the plugin
]

# Remove an installed plugin and their package versions
export extern "plugin remove" [
    name: string@"complete asdf installed plugins" # Name of the plugin
]

# Update a plugin
export extern "plugin update" [
    name: string@"complete asdf installed plugins" # Name of the plugin
    git_ref?: string # Git ref to update the plugin
]

# Update all plugins to the latest commit
export extern "plugin update --all" []

# install a package version
export extern "install" [
    name?: string # Name of the package
    version?: string # Version of the package or latest
]


# Remove an installed package version
export extern "uninstall" [
    name: string@"complete asdf installed" # Name of the package
    version: string # Version of the package
]

# Display current version
export extern "current" [
    name?: string@"complete asdf installed" # Name of installed version of a package
]

# Display path of an executable
export extern "which" [
    command: string # Name of command
]

# Display install path for an installled package version
export extern "where" [
    name: string@"complete asdf installed" # Name of installed package
    version?: string # Version of installed package
]

# Set the package local version
export extern "local" [
    name: string@"complete asdf installed" # Name of the package
    version?: string # Version of the package or latest
]

# Set the package global version
export extern "global" [
    name: string@"complete asdf installed" # Name of the package
    version?: string # Version of the package or latest
]

# Set the package to version in the current shell
export extern "shell" [
    name: string@"complete asdf installed" # Name of the package
    version?: string # Version of the package or latest
]    

# Show latest stable version of a package
export extern "latest" [
    name: string # Name of the package
    version?: string # Filter latest stable version from this version
]       

# Show latest stable version for all installed packages
export extern "latest --all" []

# List installed package versions
export extern "list" [
    name?: string@"complete asdf installed" # Name of the package
    version?: string # Filter the version
]

# List all available package versions
export def "list all" [
    name: string@"complete asdf installed" # Name of the package
    version?: string="" # Filter the version
]    {
    ^asdf list all $name $version | lines | parse "{version}" | str trim
}

# Show documentation for plugin
export extern "help" [
    name: string@"complete asdf installed" # Name of the plugin
    version?: string # Version of the plugin
]

# Execute a command shim for the current version
export extern "exec" [
    command: string # Name of the command
    ...args: any # Arguments to pass to the command
]

# Run util (default: env) inside the environment used for command shim execution
export extern "env" [
    command?: string # Name of the command
    util?: string = 'env' # Name of util to run
]

# Show information about OS, Shell and asdf Debug
export extern "info" []

# Recreate shims for version package
export extern "reshim" [
    name?: string@"complete asdf installed" # Name of the package
    version?: string # Version of the package
]

# List the plugins and versions that provide a command
export extern "shim-version" [
    command: string # Name of the command
]

# Update asdf to the latest version on the stable branch
export extern "update" []

# Update asdf to the latest version on the main branch
export extern "update --head" []

