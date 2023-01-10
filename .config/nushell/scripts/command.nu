# Helper function that returns true if a command exists in the current PATH
export def "exists" [
    name: string # name of the command
  ] {
    let result = (command -v $name | complete)
    $result.exit_code == 0
  }

