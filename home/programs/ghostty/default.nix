{ ... }:
{
  programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      installVimSyntax = true;
      settings = {
          theme = "musashi";
          cursor-style = "block";
          shell-integration-features = "no-cursor";
      };
  };

  home.file.".config/ghostty/themes" = {
      source = ./themes;
      recursive = true;
  };
}
