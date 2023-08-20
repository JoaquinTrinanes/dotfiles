# Nushell Config File

use theme.nu

let carapace_completer = {|spans: list<string>|
  carapace $spans.0 nushell $spans | from json
  | default []
  | if ($in | filter {|x|
      ($x.value | str ends-with 'ERR') and ($x.description =~ 'unknown (shorthand )?flag:')
  } | is-empty) { $in } else { null }
}

let fish_completer = {|spans: list<string>|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | $"value(char tab)description(char newline)" + $in
    | from tsv --flexible --no-infer
}

let zoxide_completer = {|spans: list<string>|
  $spans | skip 1 | zoxide query -l $in | lines | where {|x| $x != $env.PWD}
}

let git_completer = {|spans: list<string>|
  let aliases = (git config --get-regexp ^alias | lines | split column ' ' name command | update name {|x| $x.name | split row '.' | last })
  let spans_after_alias = ($spans | update 1 ($aliases | where name == $spans.1 | if ($in | is-empty) { $spans.1 } else { $in.0.command | split words }) | flatten)

  if ($spans_after_alias.1 in [checkout branch]) {
    do $fish_completer $spans_after_alias
  } else {
    do $carapace_completer $spans_after_alias
  }
}

let yadm_completer = {|spans|
  let add_aliases = (git config --get-regexp ^alias | lines | split column  ' ' name command | where command == "add" | get name | split column . _ alias | get alias)
  if $spans.1 in $add_aliases {
    do $git_completer ([git --git-dir (yadm introspect repo | str trim) --work-tree (pwd)] | append ($spans | drop nth 0))
  } else {
    do $git_completer $spans
  }
}

let default_completer = $carapace_completer
let fallback_completer = $fish_completer

let external_completer = {|spans|
    let has_alias = (scope aliases | where name == $spans.0)
    let spans = (if not ($has_alias | is-empty) {
      $spans | skip 1 | prepend ($has_alias | get expansion | split row ' ' | first)
    } else { $spans })

    match $spans.0 {
      __zoxide_z => $zoxide_completer
      __zoxide_zi => $zoxide_completer
      asdf => $fish_completer
      git => $git_completer
      gpg => $fish_completer
      nu => $fish_completer
      sd => $fish_completer
      yadm => $yadm_completer
      _ => $default_completer
    } | do $in $spans | if (($in | is-empty) and ($fallback_completer != null))) { do $fallback_completer $spans } else { $in }
 }

# The default config record. This is where much of your global configuration is setup.
$env.config = {
  ls: {
    use_ls_colors: true # use the LS_COLORS environment variable to colorize output
    clickable_links: false # enable or disable clickable links. Your terminal has to support links.
  }
  rm: {
    always_trash: false # always act as if -t was given. Can be overridden with -p
  }
  cd: {
    abbreviations: false # allows `cd s/o/f` to expand to `cd some/other/folder`
  }
  table: {
    mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
    index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
    trim: {
      methodology: wrapping # wrapping or truncating
      wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
      truncating_suffix: "…" # "..." # A suffix used by the 'truncating' methodology
    }
  }

  datetime_format: {
    normal: '%a, %d %b %Y %H:%M:%S %z'  # shows up in displays of variables or other datetime's outside of tables
    # table: '%m/%d/%y %I:%M:%S%p'        # generally shows up in tabular outputs such as ls. commenting this out will change it to the default human readable datetime format
  },
  explore: {
    help_banner: true
    exit_esc: true

    command_bar_text: '#C4C9C6'
    # command_bar: {fg: '#C4C9C6' bg: '#223311' }
    
    status_bar_background: {fg: '#1D1F21' bg: '#C4C9C6' }
    # status_bar_text: {fg: '#C4C9C6' bg: '#223311' }

    highlight: {bg: 'yellow' fg: 'black' }

    status: {
      # warn: {bg: 'yellow', fg: 'blue'} 
      # error: {bg: 'yellow', fg: 'blue'} 
      # info: {bg: 'yellow', fg: 'blue'}
    }

    try: {
      # border_color: 'red' 
      # highlighted_color: 'blue'

      # reactive: false
    }

    table: {
      # split_line: '#404040' 

      cursor: true

      line_index: true 
      line_shift: true
      line_head_top: true
      line_head_bottom: true

      show_head: true
      show_index: true

      # selected_cell: {fg: 'white', bg: '#777777'} 
      # selected_row: {fg: 'yellow', bg: '#C1C2A3'} 
      # selected_column: blue

      # padding_column_right: 2 
      # padding_column_left: 2

      # padding_index_left: 2 
      # padding_index_right: 1
    }

    config: {
      # cursor_color: {bg: 'yellow' fg: 'black' }

      # border_color: white
      # list_color: green
    }
  }
  history: {
    max_size: 100_000 # Session has to be reloaded for this to take effect
    sync_on_enter: false # Enable to share history between multiple sessions, else you have to close the session to write history to file
    file_format: "sqlite" # "sqlite" or "plaintext"
  }
  completions: {
    case_sensitive: false # set to true to enable case-sensitive completions
    quick: true  # set this to false to prevent auto-selecting completions when only one remains
    partial: true  # set this to false to prevent partial filling of the prompt
    algorithm: "prefix"  # prefix or fuzzy
    external: {
      enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up my be very slow
      max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
      completer: $external_completer
    }
  }
  filesize: {
    metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
    format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
  }
  cursor_shape: {
    emacs: line # block, underscore, line, blink_block, blink_underscore, blink_line (line is the default)
    vi_insert: line # block, underscore, line , blink_block, blink_underscore, blink_line (block is the default)
    vi_normal: block # block, underscore, line, blink_block, blink_underscore, blink_line (underscore is the default)
  }
  use_grid_icons: true
  footer_mode: "25" # always, never, number_of_rows, auto
  float_precision: 2
  # buffer_editor: "emacs" # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
  use_ansi_coloring: true
  # edit_mode: emacs # emacs, vi
  shell_integration: true # enables terminal markers and a workaround to arrow keys stop working issue
  render_right_prompt_on_last_line: false # true or false to enable or disable right prompt to be rendered on last line of the prompt.
  show_banner: false # true or false to enable or disable the banner
  hooks: {
     pre_prompt: [{||
        let direnv = (direnv export json | from json | default {})
        if ($direnv | is-empty) {
            return
        }
        $direnv
        | items {|key, value|
           {
              key: $key
              value: (if $key in $env.ENV_CONVERSIONS {
                do ($env.ENV_CONVERSIONS | get $key | get from_string) $value
              } else {
                  $value
              })
          }
        } | transpose -ird | load-env
    }]
    pre_execution: []
    env_change: {
      PWD: [
        # {|before, after|
        #   null  # replace with source code to run if the PWD environment is different since the last repl input
        # }
      ]
    }
    display_output: {
      if (term size).columns >= 100 { table -e } else { table }
    }
    command_not_found: []
  }
  menus: ([
      # Configuration for default nushell menus
      # Note the lack of source parameter
      {
        name: completion_menu
        only_buffer_difference: false
        marker: "| "
        type: {
            layout: columnar
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
        }
      }
      {
        name: history_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: list
            page_size: 10
        }
      }
      {
        name: help_menu
        only_buffer_difference: true
        marker: "? "
        type: {
            layout: description
            columns: 4
            col_width: 20   # Optional value. If missing all the screen width is used to calculate column width
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
      }
      # Example of extra menus created using a nushell source
      # Use the source field to create a list of records that populates
      # the menu
      {
        name: commands_menu
        only_buffer_difference: false
        marker: "# "
        type: {
            layout: columnar
            columns: 4
            col_width: 20
            col_padding: 2
        }
        source: { |buffer, position|
            scope commands
            | where name =~ $buffer
            | each { |it| {value: $it.name description: $it.usage} }
        }
      }
      {
        name: vars_menu
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: list
            page_size: 10
        }
        source: { |buffer, position|
            scope variables
            | where name =~ $buffer
            | sort-by name
            | each { |it| {value: $it.name description: $it.type} }
        }
      }
      {
        name: commands_with_description
        only_buffer_difference: true
        marker: "# "
        type: {
            layout: description
            columns: 4
            col_width: 20
            col_padding: 2
            selection_rows: 4
            description_rows: 10
        }
        source: { |buffer, position|
            scope commands
            | where name =~ $buffer
            | each { |it| {value: $it.name description: $it.usage} }
        }
      }
    ] | each {|menu| $menu | upsert style {}}
  )
  keybindings: [
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: [emacs vi_normal vi_insert]
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
        ]
      }
    }
    {
      name: completion_previous
      modifier: shift
      keycode: backtab
      mode: [emacs, vi_normal, vi_insert] # Note: You can add the same keybinding to all modes by using a list
      event: { send: menuprevious }
    }
    {
      name: history_menu
      modifier: control
      keycode: char_r
      mode: emacs
      event: { send: menu name: history_menu }
    }
    {
      name: next_page
      modifier: control
      keycode: char_x
      mode: emacs
      event: { send: menupagenext }
    }
    {
      name: undo_or_previous_page
      modifier: control
      keycode: char_z
      mode: emacs
      event: {
        until: [
          { send: menupageprevious }
          { edit: undo }
        ]
       }
    }
    {
      name: yank
      modifier: control
      keycode: char_y
      mode: emacs
      event: {
        until: [
          {edit: pastecutbufferafter}
        ]
      }
    }
    {
      name: unix-line-discard
      modifier: control
      keycode: char_u
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          {edit: cutfromlinestart}
        ]
      }
    }
    {
      name: kill-line
      modifier: control
      keycode: char_k
      mode: [emacs, vi_normal, vi_insert]
      event: {
        until: [
          {edit: cuttolineend}
        ]
      }
    }
    # Keybindings used to trigger the user defined menus
    {
      name: commands_menu
      modifier: control
      keycode: char_t
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_menu }
    }
    {
      name: vars_menu
      modifier: alt
      keycode: char_o
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: vars_menu }
    }
    {
      name: commands_with_description
      modifier: control
      keycode: char_s
      mode: [emacs, vi_normal, vi_insert]
      event: { send: menu name: commands_with_description }
    }
  ]
}


source starship.nu

source zoxide.nu
source atuin.nu
use theme.nu

overlay use aliases
overlay use completions

