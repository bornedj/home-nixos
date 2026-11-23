{
  description = "Hyprland with quickshell on nix, btw";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen = {
      url = "github:/InioX/Matugen";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
    in
    {
      # Shared home-manager modules, also consumed by other hosts as a flake
      # input. See modules/home/default.nix.
      homeModules = import ./modules/home;

      nixosConfigurations = {
        daniel = nixpkgs.lib.nixosSystem {
          specialArgs = with inputs; {
            inherit zen-browser;
            inherit matugen;
            inherit quickshell;
          };
          modules = [
            ./nixos/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.daniel = import ./home/daniel.nix;
              home-manager.extraSpecialArgs = { inherit inputs self; };
            }
          ];
        };
      };

      # Evaluates the shared modules with every feature switched on, away from
      # any host, so an option or Lua interpolation error shows up in
      # `nix flake check` even when no host enables that feature.
      checks.${system}.homeModules =
        let
          evaluated = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              self.homeModules.default
              {
                home = {
                  username = "check";
                  homeDirectory = "/home/check";
                  stateVersion = "25.11";
                };
                bornedj = {
                  flake = {
                    dir = "/home/check/flake";
                    host = "check";
                  };
                  workspace.reposDir = "/home/check/repos";
                  git.enable = true;
                  cli.enable = true;
                  zsh.enable = true;
                  tmux.enable = true;
                  scripts.enable = true;
                  agentConfig.enable = true;
                  nvim.enable = true;
                };
              }
            ];
          };
          # String context is dropped so the check stays an evaluation and does
          # not pull every referenced package into a build.
          plain = s: builtins.unsafeDiscardStringContext (toString s);
          summary = {
            files = lib.mapAttrs (_: file: {
              text = if file ? text then plain file.text else null;
              source = plain file.source;
            }) evaluated.config.home.file;
            packages = map (p: plain p.name) evaluated.config.home.packages;
            activation = builtins.attrNames evaluated.config.home.activation;
          };
        in
        pkgs.writeText "home-modules-eval.json" (builtins.toJSON summary);
    };
}
