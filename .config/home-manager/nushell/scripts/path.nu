export def home [path?: string] {
    $env.HOME | path join $path
}
