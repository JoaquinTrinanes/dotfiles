{
  add_newline = true;
  character = {
    success_symbol = "[➜](bold green)";
    error_symbol = "[➜](bold blue)";
  };
  aws = { disabled = true; };
  directory = { truncation_length = 5; };
  php = { format = "via [$symbol]($style)"; };
  python = {
    format = "via [\${symbol}\${pyenv_prefix}(\${version})]($style) ";
  };
  status = {
    disabled = false;
    symbol = "✘";
  };
  shell = {
    disabled = false;
    nu_indicator = "";
    format = "([$indicator]($style) )";
  };
}
