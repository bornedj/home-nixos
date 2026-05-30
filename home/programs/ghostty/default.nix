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
}
