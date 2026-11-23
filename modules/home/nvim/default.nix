{ lib, ... }:
{
  options.bornedj.nvim.enable = lib.mkEnableOption "the shared neovim configuration";
}
