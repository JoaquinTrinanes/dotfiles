def 'nu-complete artisan commands' [] {
    php artisan list --format=json
    | from json
    | get commands
    | select name description
    | where {|x| not ($x.name | str starts-with '_') }
    | rename value description
}

export extern main [
    command: string@'nu-complete artisan commands'
    --help (-h)
]
