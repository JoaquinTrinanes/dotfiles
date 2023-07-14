{ self, config, pkgs, lib, ... }:
let
  inherit (builtins) fetchGit;
  nix-colors = import <nix-colors> { };
in {
  imports = [ nix-colors.homeManagerModules.default ];
  colorScheme = nix-colors.colorSchemes.nord;

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
  home.packages = with pkgs;
    [
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

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

  xdg.configFile."nushell/scripts".source = ./nushell/scripts;
  xdg.configFile."nvim" = {
    source = (fetchGit "https://github.com/NvChad/NvChad.git").outPath;
    recursive = true;
  };
  xdg.configFile."nvim/lua/custom".source = ./nvim;

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
  home.sessionVariables = { EDITOR = "lvim"; };

  home.shellAliases = {
    la = "ls -la";
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

      settings = import ./starship;
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
    bash = {
      enable = true;
      initExtra = ''
        if (vivid themes | grep '^flavours$' > /dev/null); then
          export LS_COLORS="$(vivid generate flavours)"
        fi

        if ! command -v nu &>/dev/null; then
            return
        fi

        if [[ $(ps --no-header --pid=$PPID --format=comm) != "nu" && -z ''${BASH_EXECUTION_STRING} ]]; then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION='''
            exec nu $LOGIN_OPTION
        fi
      '';
    };
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
    ripgrep = { enable = true; };
    neovim = { enable = true; };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
