export def theme [] {
    let theme = open ~/.cache/wal/colors.yml
    let colors = $theme.colors
    # let special = $theme.special

    let base00 = $colors.color0 # Default Background
    let base01 = $colors.color1 # Lighter Background (Used for status bars, line number and folding marks)
    let base02 = $colors.color2 # Selection Background
    let base03 = $colors.color3 # Comments, Invisibles, Line Highlighting
    let base04 = $colors.color4 # Dark Foreground (Used for status bars)
    let base05 = $colors.color5 # Default Foreground, Caret, Delimiters, Operators
    let base06 = $colors.color6 # Light Foreground (Not often used)
    let base07 = $colors.color7 # Light Background (Not often used)
    let base08 = $colors.color8 # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    let base09 = $colors.color9 # Integers, Boolean, Constants, XML Attributes, Markup Link Url
    let base0a = $colors.color10 # Classes, Markup Bold, Search Text Background
    let base0b = $colors.color11 # Strings, Inherited Class, Markup Code, Diff Inserted
    let base0c = $colors.color12 # Support, Regular Expressions, Escape Characters, Markup Quotes
    let base0d = $colors.color13 # Functions, Methods, Attribute IDs, Headings
    let base0e = $colors.color14 # Keywords, Storage, Selector, Markup Italic, Diff Changed
    let base0f = $colors.color15 # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>

    let base16_theme = {
        separator: $base03
        leading_trailing_space_bg: $base04
        header: $base0b
        date: $base0e
        filesize: $base0d
        row_index: $base0c
        bool: $base08
        int: $base0b
        duration: $base08
        range: $base08
        float: $base08
        string: $base04
        nothing: $base08
        binary: $base08
        cellpath: $base08
        hints: dark_gray

        shape_garbage: { fg: $base07 bg: $base08 attr: b} # base16 white on red
        shape_bool: $base0d
        shape_int: { fg: $base0e attr: b}
        shape_float: { fg: $base0e attr: b}
        shape_range: { fg: $base0a attr: b}
        shape_internalcall: { fg: $base0c attr: b}
        shape_external: $base0c
        shape_externalarg: { fg: $base0b attr: b}
        shape_literal: $base0d
        shape_operator: $base0a
        shape_signature: { fg: $base0b attr: b}
        shape_string: $base0b
        shape_filepath: $base0d
        shape_globpattern: { fg: $base0d attr: b}
        shape_variable: $base0e
        shape_flag: { fg: $base0d attr: b}
        shape_custom: {attr: b}
    }
    $base16_theme
}
