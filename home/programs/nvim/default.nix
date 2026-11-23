{ pkgs, ... }:

{
  programs.neovim = {
    # generating the colors file with matugen
    initLua = ''
      require("matugen")
      ${builtins.readFile ./plugins/colorscheme.lua}
    '';

    plugins = [ pkgs.vimPlugins.base16-nvim ];
  };
}
