# Hyprland with quickshell on nix, btw

This flake is my home setup for hyprland on nixos

## built with

- Hyprland - compositor
- QuickShell - for components
- Matugen - dynamic theming from images

## Shared home-manager modules

`modules/home` holds the home-manager config this flake shares with other
hosts (nvim, tmux, zsh, git, cli packages, helper scripts, agent config).
The flake exports them as `homeModules.*`; `homeModules.default` imports
them all. Every module is gated behind `bornedj.<program>.enable`, so a host
only gets what it opts in to, and host facts come from `bornedj.flake.*` and
`bornedj.workspace.*` (see `modules/home/options.nix`). Themes stay with the
host: this flake layers matugen, base16 and dotbar on top of the shared
modules from `home/`.

Another host consumes them as a flake input:

```nix
inputs.common = {
  url = "github:bornedj/home-nixos";
  inputs.nixpkgs.follows = "nixpkgs";
  inputs.home-manager.follows = "home-manager";
  inputs.sops-nix.follows = "sops-nix";
};
```

and imports `inputs.common.homeModules.default` in its home-manager config.
`nix flake check` evaluates the modules with every feature switched on
(`checks.x86_64-linux.homeModules`), so an option or Lua error shows up here
before a consumer bumps its lock.

## TODO
- [ ] status bar
    - [x] cpu util
    - [x] gpu util
    - [x] mem util
    - [x] clock
    - [x] workspace selector
    - [ ] power icon with drawer
    - [ ] newtork
    - [ ] volume controls
- [ ] setup screensharing
- [x] setup screenshotting
- [x] matugen setup
    - [x] nvim
    - [x] ghostty
    - [x] hyprland
    - [x] tmux
    - [x] quickshell
- [ ] application launcher
- [ ] window fuzzy finder
- [ ] workspace manager - SUPER tab on windows
- [ ] file explorer
