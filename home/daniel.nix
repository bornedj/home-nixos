{
  pkgs,
  inputs,
  self,
  config,
  ...
}:

{
  home.username = "daniel";
  home.homeDirectory = "/home/daniel";
  programs.home-manager.enable = true;
  home.stateVersion = "25.11";

  imports = [
    self.homeModules.default
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

  bornedj = {
    flake = {
      dir = "${config.home.homeDirectory}/dotfiles";
      host = "daniel";
    };
    workspace.reposDir = "${config.home.homeDirectory}/github";
    git.enable = true;
    cli.enable = true;
    zsh = {
      enable = true;
      generationRetention = "5d";
      secretsFile = "${config.bornedj.flake.dir}/home/sops/home.yaml";
    };
    agentConfig.enable = true;
    scripts.enable = true;
    tmux = {
      sessions = [
        {
          name = "configs";
          dir = config.bornedj.flake.dir;
          key = "u";
        }
        {
          name = "github_repos";
          dir = config.bornedj.workspace.reposDir;
          key = "g";
        }
        {
          name = "obsidian";
          dir = "${config.home.homeDirectory}/obsidian";
          key = "o";
        }
      ];
      sessionizerRoots = [ config.bornedj.workspace.reposDir ];
    };
  };

  programs.git.settings.user.email = "borne.danielj@gmail.com";

  home.packages = with pkgs; [
    nodejs_24

    # music
    cider-2
    grim
  ];

  programs.discord = {
    enable = true;
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
