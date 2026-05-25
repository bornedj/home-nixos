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
  };

  wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      systemd.enable = true;
  };
   
  # dotfiles
  home.file.".local/bin/tmux-sessionizer.sh" = {
    source = ./.local/bin/tmux-sessionizer.sh;
    executable = true;
  };
  home.file.".local/bin/tmux-session-init.sh" = {
    source = ./.local/bin/tmux-session-init.sh;
    executable = true;
  };
  home.file.".config/ghostty/config.ghostty" = {
    source = ./programs/ghostty/config.ghostty;
  };
  home.file.".config/monitors.xml" = {
      source = ../nixos/monitors.xml;
  };
}
