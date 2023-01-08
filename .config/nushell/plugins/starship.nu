let-env STARSHIP_SHELL = "nu"
let-env STARSHIP_SESSION_KEY = (random chars -l 16)
let-env PROMPT_MULTILINE_INDICATOR = (starship prompt --continuation)

# let starship_path

# Does not play well with default character module.
# TODO: Also Use starship vi mode indicators?
let-env PROMPT_INDICATOR = ""

let-env PROMPT_COMMAND = {
    # jobs are not supported
    let width = (term size).columns
    starship prompt $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)"
}

# Whether we can show right prompt on the last line
let has_rprompt_last_line_support = (version).version >= 0.71.0

# Whether we have config items
let has_config_items = (not ($env | get -i config | is-empty))

if $has_rprompt_last_line_support {
    let config = if $has_config_items {
        $env.config | upsert render_right_prompt_on_last_line true
    } else {
        {render_right_prompt_on_last_line: true}
    }
    {config: $config}
} else {
    { }
} | load-env

let-env PROMPT_COMMAND_RIGHT = {
    if $has_rprompt_last_line_support {
        let width = (term size).columns
        starship prompt --right $"--cmd-duration=($env.CMD_DURATION_MS)" $"--status=($env.LAST_EXIT_CODE)" $"--terminal-width=($width)"
    } else {
        ''
    }
}