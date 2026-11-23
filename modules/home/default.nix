# Home-manager modules shared between this flake and other hosts that take it
# as a flake input. Every program module is gated behind `bornedj.<program>.enable`,
# so importing `default` is a no-op until a host opts in. Modules only take
# `config`, `lib` and `pkgs`; nothing here reads flake inputs.
let
  programs = {
    git = ./git;
    cli = ./cli;
    zsh = ./zsh;
    tmux = ./tmux;
    scripts = ./scripts;
    agent-config = ./agent-config;
    nvim = ./nvim;
  };
in
programs
// {
  options = ./options.nix;
  default = {
    imports = [ ./options.nix ] ++ builtins.attrValues programs;
  };
}
