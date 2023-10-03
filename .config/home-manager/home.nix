{ self, config, pkgs, overlays, nix-colors, ... }: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "joaquin";
  home.homeDirectory = "/home/joaquin";

  imports = [ nix-colors.homeManagerModules.default ];

  colorScheme = nix-colors.colorSchemes.catppuccin-frappe;

  nixpkgs = { inherit overlays; };

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
    nil

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

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
    ll = "ls -la";
    la = "ls -a";
    hm = "home-manager";
    c = "yadm";
    g = "git";
    vim = "nvim";
  };

  programs = {
    # Let Home Manager install and manage itself.
    # bash = {
    #   enable = true;

    # };
    home-manager.enable = true;
    nushell = {
      enable = true;
      shellAliases = config.home.shellAliases;
      configFile.text = ''
        $env.config = {}
        $env.config.show_banner = false
        $env.config.keybindings = []
      '';
      # configFile.source = ~/.config/nushell/config.nu; # ./nushell/config.nu;
      # envFile.source = ~/.config/nushell/env.nu; # ./nushell/config.nu;
      # envFile.source = ./nushell/env.nu;
    };
    ripgrep.enable = true;
    rtx.enable = true;
    direnv.enable = true;
    zoxide = {
      enable = true;
      options = [ "--cmd=j" ];
    };
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        continuation_prompt = "[:::](bright-black) ";
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
          format = "([$indicator](style) )";
        };
      };
    };
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
    };
    carapace.enable = true;
    # neovim = {
    #   enable = true;
    #   defaultEditor = true;
    #   vimAlias = true;
    #   # plugins = with pkgs.vimPlugins; [ LazyVim ];
    # };
    wezterm = {
      enable = true;
      colorSchemes = with config.colorScheme.colors; {
        base16 = {
          foreground = base05;
          background = base00;
          cursor_bg = base05;
          cursor_border = base05;
          selection_bg = base05;
          selection_fg = base00;

          ansi = [ base00 base08 base0B base0A base0D base0E base0C base05 ];

          brights = [ base03 base08 base0B base0A base0D base0E base0C base07 ];
        };
      };
      extraConfig = ''
        local config = wezterm.config_builder()

        config.color_scheme = "base16"

        return config
      '';
    };

  };
}
