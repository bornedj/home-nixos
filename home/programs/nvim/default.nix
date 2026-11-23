{ lib, pkgs, ... }:

{
  programs.neovim = {
    plugins = [ pkgs.vimPlugins.base16-nvim ];

    # Runs from init.lua, before any plugin/ file: a colorscheme clears every
    # highlight group, so plugins that define groups during their own setup
    # (obsidian does) have to run after it.
    initLua = lib.mkOrder 400 (builtins.readFile ./colors.lua);
  };
}
