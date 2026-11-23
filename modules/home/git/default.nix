{ config, lib, ... }:
let
  cfg = config.bornedj.git;
in
{
  options.bornedj.git.enable = lib.mkEnableOption "the shared git and gh configuration";

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user.name = "Daniel Borne";
        core.symlinks = false;
        pull.rebase = true;
        merge.rebase = true;
        push.autoSetupRemote = "true";
        init.defaultBranch = "main";
        alias.ri = "!git rebase -i $(git merge-base @ $(git branch -r | rg -m1 -o 'origin/(main|master)$' | cut -d/ -f2))";
      };
      ignores = [ "shell.nix" ];
    };

    programs.gh = {
      enable = true;
      settings.editor = "nvim";
    };
  };
}
