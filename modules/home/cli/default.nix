{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.bornedj.cli;
in
{
  options.bornedj.cli.enable = lib.mkEnableOption "the shared command line packages";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # languages
      rustup
      lua

      # rust cli
      ripgrep
      zoxide
      fd
      yazi

      # haskell
      cabal-install
      ghc
      haskellPackages.hoogle
      haskellPackages.ghcid

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
    ];

    programs.nix-search-tv.enable = true;
  };
}
