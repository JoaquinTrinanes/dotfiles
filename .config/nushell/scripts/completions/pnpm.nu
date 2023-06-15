def get_package_json_location [] {
  if ('package.json' | path exists) {
    'package.json' | path expand
  } else {
    pnpm root | str trim
  }
}

def 'nu-complete pnpm user scripts' [] {
  try {
    get_package_json_location | open | get scripts | transpose value description
  } catch {
   []
  }
}

def 'nu-complete pnpm package binaries' [] {
 try {
  get_package_json_location | path dirname | path join node_modules/.bin | ls $in | select name | rename value | insert description 'Package binary' | update value { path basename }
 } catch {
   []
 }
}


def 'nu-complete pnpm' [] {
  let normal_completions = (do $external_completer ['pnpm' ''] | str trim)
  let script_completions = (nu-complete pnpm user scripts | append (nu-complete pnpm package binaries) | filter {|x| not ($x.value in ($normal_completions | get value)) })
  $normal_completions | append $script_completions | sort-by value
}

export extern main [
  command?:string@'nu-complete pnpm'
]

