{ self, config, pkgs, lib, ... }: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "joaquin";
  home.homeDirectory = "/home/joaquin";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release introduces backwards incompatible changes.
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    # nixfmt
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    nixfmt
    cargo

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  xdg.configFile."nushell/scripts".source = ./nushell/scripts;
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/joaquin/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.shellAliases = {
    ll = "ls -l";
    hm = "home-manager";
    vim = "lvim";
    c = "yadm";
  };

  programs = {
    zoxide = {
      enable = true;
      options = [ "--cmd" "j" ];
    };
    starship = {
      enable = true;

      settings = {
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
      };
    };
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        filter_mode_shell_up_key_binding = "session";
        style = "compact";
        history_filter = [ "^\\s" ];

      };
    };
    # bash = { enable = true; };
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableAutosuggestions = true;
      antidote = {
        enable = true;
        useFriendlyNames = true;
      };
    };

    nushell = {
      enable = true;
      shellAliases = config.home.shellAliases;
      configFile.source = ./nushell/config.nu;
      envFile.source = ./nushell/env.nu;
      extraConfig = ''
        $env.PROMPT_MULTILINE_INDICATOR = $"(ansi grey)::: (ansi reset)"
      '';
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
