{ ... }:

{
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
      merge = {
        rebase = true;
      };
      push = {
        autoSetupRemote = "true";
      };
      init.defaultBranch = "main";
      alias = {
        ri = "!git rebase -i $(git merge-base @ $(git branch -r | rg -m1 -o 'origin/(main|master)$' | cut -d/ -f2))";
      };
    };
    ignores = [
      "shell.nix"
    ];
  };

  programs.gh = {
    enable = true;
    settings = {
      editor = "nvim";
    };
  };
}
