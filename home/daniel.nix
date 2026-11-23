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
    ./programs/ghostty
    ./programs/quickshell
    ./programs/steam
    ./sops
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
    fd
    yazi

    # haskell
    cabal-install
    ghc
    haskellPackages.hoogle
    ghcid

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

    # agents
    claude-code
    
    # music
    cider-2
    grim
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

  programs.nix-search-tv.enable = true;

  home.file.".local/bin" = {
    source = ./.local/bin;
    executable = true;
    recursive = true;
  };
  # file used for dynamic store path import of lua snippets
  home.file.".config/nvim/lua/hypr.lua" = {
    text = ''
    return {
        stubs = "${pkgs.hyprland}/share/hypr/stubs"
    }
    '';
  };

  home.file.".config/nvim/lua/qmlls_path.lua".text = ''
  return {
        stubs = "${pkgs.kdePackages.qtdeclarative}"
  }
  '';
}
