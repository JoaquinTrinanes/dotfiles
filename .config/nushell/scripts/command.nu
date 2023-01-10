# Helper function that returns true if a command exists in the current PATH
export def "exists" [
    name: string # name of the command
  ] {
  if (which $name | is-empty) { false } else { true }
  }

