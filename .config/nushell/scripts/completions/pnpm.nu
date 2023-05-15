def get_package_json_location [] {
  if ('package.json' | path exists) {
    'package.json' | path expand
  } else {
    pnpm root | str trim
  }
}

def 'complete pnpm user scripts' [] {
  let location = ()
  try {
    get_package_json_location | open | get scripts | transpose value description
  } catch {
   []
  }
}

def 'complete pnpm' [] {
  let normal_completions = (do $external_completer ['pnpm' ''] | str trim)
  let script_completions = (complete pnpm user scripts | filter {|x| not ($x.value in ($normal_completions | get value)) })
  $normal_completions | append $script_completions | sort-by value
}

export extern "main" [
  command?:string@'complete pnpm'
]

