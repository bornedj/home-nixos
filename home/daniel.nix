{ pkgs, inputs, ... }:

{
  home.username = "daniel";
  home.homeDirectory = "/home/daniel";
  programs.home-manager.enable = true;
  home.stateVersion = "25.11";

  imports = [ 
    ./programs/zsh.nix
    ./programs/nvim
    ./programs/tmux
    ./programs/hyprland
    ./programs/matugen
    inputs.sops-nix.homeManagerModules.sops
  ];
  home.packages = with pkgs; [
    # languages
    rustup
    lua
    nodejs_24

    # rust cli
    ripgrep
    zoxide

    # cli utils
    fzf
    curl
    age
    jq
    yq
    tree

    # postgres
    postgresql_17

    # secrets
    sops
    
    # music
    cider-2
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Daniel Borne";
        email = "borne.danielj@gmail.com";
      };
      core = {
        symlinks = false;
      };
      pull = {
        rebase = true;
      };
      push = {
        autoSetupRemote = "true";
      };
      init.defaultBranch = "main";
    };
    ignores = [
        "shell.nix"
    ];
  };

  programs.discord = {
      enable = true;
  };

  programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      installVimSyntax = true;
      settings = {
          theme = "Nord";
          cursor-style = "block";
          shell-integration-features = "no-cursor";
      };
  };

  programs.nix-search-tv.enable = true;

  # dotfiles
  home.file.".local/bin/tmux-sessionizer.sh" = {
    source = ./.local/bin/tmux-sessionizer.sh;
    executable = true;
  };
  home.file.".local/bin/tmux-session-init.sh" = {
    source = ./.local/bin/tmux-session-init.sh;
    executable = true;
  };
  # file used for dynamic store path import of lua snippets
  home.file.".config/nvim/lua/hypr.lua" = {
    text = ''
    return {
        stubs = "${pkgs.hyprland}/share/hypr/stubs"
    }
    '';
  };
}
