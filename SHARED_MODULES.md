# How the shared home-manager modules work

This flake is the single source of the home-manager config that two
machines share: this one (`.#daniel`, Hyprland desktop) and a work WSL box
whose private flake consumes it as a flake input. This document explains
where shared code goes, how each flake sources it, why the setup is built
this way, and how the Neovim layers load.

## Where shared code lives

Everything shared is under `modules/home/`, one directory per program:

```
modules/home/
  default.nix          exports { default, options, git, cli, zsh, tmux,
                       scripts, agent-config, nvim }
  options.nix          host facts: bornedj.flake.{dir,host},
                       bornedj.workspace.{reposDir,clipboardCommand}
  git/                 git settings, gh
  cli/                 packages every host wants
  zsh/                 oh-my-zsh, aliases, helper functions
  tmux/                tmux.conf, session binds, the Claude status inject
  scripts/             ~/.local/bin helpers generated from the tmux options
  agent-config/        CLAUDE.md, ORCHESTRATION.md, code-review-doc skill,
                       the Claude Code tmux hooks
  nvim/                the Neovim module, its Lua core and optional layers
```

Rules that keep a module shareable:

- Every module is gated by `bornedj.<program>.enable` (default off), so
  importing `homeModules.default` changes nothing until a host opts in.
- Modules take only `config`, `lib` and `pkgs`. They never read flake
  inputs, so the consumer can pass its own.
- Paths come from `config.home.homeDirectory`,
  `config.home.profileDirectory` or the `bornedj.*` host facts, never from
  a hardcoded user.
- Anything a host may want to change is set with `lib.mkDefault` (the
  oh-my-zsh theme, for example). Hosts override by plain assignment;
  `lib.mkForce` is a last resort.
- Optional features are neutral switches (`bornedj.nvim.java.enable`,
  `bornedj.tmux.claudeStatus.enable`), never a "this is the work machine"
  flag.
- Themes are not shared. Each host layers its own colours on top.
- Nothing in this repo may identify the work environment. Work-only
  content lives in the consumer's own layer directory.

To add something shared: put it in the module for its program (or a new
`modules/home/<name>/default.nix` registered in `modules/home/default.nix`),
enable it in `home/daniel.nix` here, then enable it on the other host once
its lock is bumped. `nix flake check` evaluates every module with every
feature on (`checks.x86_64-linux.homeModules`), away from any host, so a
broken option or Lua interpolation fails here before a consumer sees it.

## How each flake sources it

Here, `flake.nix` exports `homeModules = import ./modules/home;` and passes
`self` to home-manager through `extraSpecialArgs`. `home/daniel.nix` then
does what any consumer does:

```nix
imports = [ self.homeModules.default ... ];
bornedj = {
  flake = { dir = "${config.home.homeDirectory}/dotfiles"; host = "daniel"; };
  workspace.reposDir = "${config.home.homeDirectory}/github";
  git.enable = true;
  zsh = { enable = true; generationRetention = "5d"; ... };
  nvim = { enable = true; copilot.enable = true; qml.enable = true; ... };
};
```

Host-only remainders stay in thin files under `home/programs/` (the
oh-my-zsh theme and Hyprland login hook in `zsh.nix`, the matugen colour
file plus dotbar in `tmux/`, base16 plus the matugen palette loader in
`nvim/`).

The work flake adds this repo as an input and imports the same attribute:

```nix
inputs.common = {
  url = "github:bornedj/home-nixos";
  inputs.nixpkgs.follows = "nixpkgs";
  inputs.home-manager.follows = "home-manager";
  inputs.sops-nix.follows = "sops-nix";
};
```

```nix
imports = [ inputs.common.homeModules.default ./work/zsh.nix ... ];
bornedj = {
  nvim = { enable = true; java.enable = true; wsl.enable = true; };
  # ...
};
```

The `follows` lines matter: without them the consumer would evaluate two
nixpkgs trees and the pins could drift apart again. Its work layer
directory holds everything work-specific (git email and hooks, work
aliases and tokens, the Nord tmux theme, the database list, gitlab.vim,
agent-config addenda), expressed as ordinary home-manager definitions that
merge with the shared ones: lists concatenate (`programs.neovim.plugins`,
`home.packages`), `lines` concatenate in `mkOrder` order
(`programs.tmux.extraConfig`, `programs.zsh.initContent`), attrsets merge
(`shellAliases`, `programs.git.settings`).

Day to day on the consumer: iterate against a local checkout with
`nixos-rebuild build --flake .#nixos --override-input common path:<checkout>`,
and after a change lands here run `nix flake update common` and switch.
Drift can only show up as a stale `common` entry in that lock file.

## Is this idiomatic?

Yes. Exporting modules from a flake and consuming them as an input is how
the ecosystem itself composes: nixpkgs, home-manager, sops-nix, nixos-wsl
and nix-community projects all expose `nixosModules.*` /
`homeModules.*` this way, and `homeModules` is the output name `nix flake
check` recognises. Gating with `mkEnableOption` and letting the module
system merge host definitions on top is the intended composition model;
it replaces copy-and-edit with "define once, enable per host".

Two parts are conventions rather than ecosystem standards:

- The `bornedj.*` option namespace. Personal flakes commonly pick a short
  namespace for their own options; the name is arbitrary.
- Packaging the Neovim config as a vim plugin (`buildVimPlugin` of a
  directory with `plugin/`, `lua/`, `after/`). This is what nixvim and
  most larger Nix Neovim setups end up doing, because it lets Nix decide
  which Lua lands on the runtimepath instead of splicing Lua into strings.

## Alternatives that were considered

- **One flake per program.** Rejected: every flake carries its own lock and
  nixpkgs pin, so the drift moves into the locks instead of going away.
- **A third, shared-only repo.** Possible, and it would spare the consumer
  from seeing the Hyprland and quickshell inputs. Rejected because flake
  inputs are lazy: the consumer copies their lock entries but never
  fetches them, and one repo fewer is simpler. If fetch cost ever matters
  the modules directory can move without changing the consumer.
- **Copying files between repos** (the previous state). Rejected: that is
  what produced the drift.
- **Shared Nix functions instead of modules.** Functions return values; they
  do not merge. The module system is what lets a host add a plugin, an
  alias or a tmux line without touching the shared definition.
- **A `profile = "work"` style flag.** Rejected in favour of neutral
  feature switches, so the public repo never encodes what the other host
  is.
- **Keeping Lua in `initLua` strings with Nix interpolation.** Rejected:
  string splicing hides load order, makes secrets end up in Lua source,
  and ties config to the plugin list. Runtimepath layers pair each piece
  of Lua with the package that installs it, and Nix-computed values travel
  through one generated Lua module (`lua/bornedj/generated.lua`, and a
  generated secrets module on the work side, which holds only file paths).
- **`mkForce` from the host.** Kept as a last resort; `mkDefault` in the
  shared module is used wherever a host is expected to differ.

## How the Neovim layers load

The config is split into packages that home-manager links into
`~/.local/share/nvim/site/pack/hm/start/`:

- `bornedj-nvim`: the core layer (`modules/home/nvim/core/`).
- `bornedj-generated`: `lua/bornedj/generated.lua`, written by Nix with
  `lib.generators.toLua`: `lua_libraries`, `obsidian_workspaces`, and the
  `jdtls_cmd` / `qmlls_cmd` store paths when those layers are on.
- `bornedj-copilot`, `bornedj-java`, `bornedj-qml`, `bornedj-wsl`: optional
  layers (`modules/home/nvim/layers/<name>/`). Each is added together with
  its plugins and packages under `lib.mkIf cfg.<name>.enable`, so the Lua
  for a feature is only on the runtimepath when its dependencies are.
- Host layers: this repo's `home/programs/nvim/` (base16 plus the matugen
  palette loader), the work flake's own nvim layer (gitlab.vim, onenord,
  the database list).

Startup then runs in this order:

1. **`init.lua`**, assembled by home-manager from `programs.neovim.initLua`
   pieces in `mkOrder` order: home-manager's own preamble at 200, the
   shared `options.lua` at 300 (sets `mapleader` and `vim.opt`), the host's
   colour script at 400. Nothing else goes through `initLua`; no plugin
   `config` strings are used.

   Colours run here, before any plugin, on purpose: `:colorscheme` clears
   every highlight group, and obsidian.nvim defines its groups only once
   during `setup()`. Running the colourscheme from `after/plugin` wiped
   them. From `init.lua` the colourscheme is in place before any `setup()`
   runs. `require('base16-colorscheme')` and `require('onenord')` resolve
   at this point because Neovim's loader searches start packages before
   `packloadall`.
2. **`plugin/` files** of every start package. Order across packages is
   not something to rely on, so the core layer has exactly one such file,
   `plugin/bornedj.lua`, which `require`s the `bornedj.*` modules in an
   explicit list:

   `remap, fugitive, telescope, harpoon, comment, treesitter, trouble,
   devicons, which-key, claude-code, undotree, obsidian, dadbod, lsp, cmp`

   Two orderings in that list are deliberate. `remap` comes before
   `harpoon` so harpoon's `<M-x>` (file 6) wins over remap's `<M-x>`
   decrement, which is what happened before the refactor. `lsp` comes
   before `cmp`: `lsp.lua` sets `vim.lsp.config('*', { capabilities =
   cmp_nvim_lsp capabilities })` and calls `vim.lsp.enable { ... }` for the
   core servers, so the capabilities are registered before any server
   starts; `cmp.lua` then configures completion. Each `require` is wrapped
   in `xpcall` with a traceback, so one failing module (obsidian without
   its vault directories, say) is reported without stopping lsp and cmp.

   Optional layers also use `plugin/` files for things that must run at
   this stage: `bornedj-java.lua` adds the `LspAttach` autocmd that attaches
   the buffer-local DAP maps for `jdtls` clients and calls
   `vim.lsp.enable 'jdtls'`; `bornedj-qml.lua` enables `qmlls`;
   `bornedj-wsl.lua` defines the Windows maps (`<leader>gB` for git-bash,
   because telescope owns `<leader>gb`).
3. **`lsp/<server>.lua` and `after/lsp/<server>.lua`** are read lazily when
   a server is enabled. nvim-lspconfig ships the stock definitions in
   `lsp/`; our per-server settings live in `after/lsp/` (eslint,
   rust_analyzer, lua_ls, emmet_ls, hls, and jdtls / qmlls in their
   layers) because `after/` directories are merged after every `lsp/` on
   the runtimepath, so nvim-lspconfig's values never override ours.
   `lua_ls` reads `generated.lua_libraries`; `jdtls` reads
   `generated.jdtls_cmd` and uses `root_markers` (`pom.xml`, `mvnw`,
   `gradlew`, `.git`).
4. **`after/plugin/` files**, which run after every `plugin/` file. Copilot
   (`bornedj-copilot`) and gitlab.vim (work layer) live here. Both map
   insert `<C-y>`. nvim-cmp wraps whatever `<C-y>` map exists on the first
   `InsertEnter` and falls back to it when the completion menu is closed,
   so these maps have to exist before that wrapper runs; `after/plugin` is
   the stage that guarantees it. Gitlab's map only appears once its
   language server has started, which is the same timing as before.

`after/queries/markdown/*.scm` in the core layer extend the stock markdown
queries (`; extends`), which the old `initLua` setup never put on the
runtimepath.

The obsidian vault list is built the same way as everything else: the
module defines `personal` and `daily_notes` with `lib.mkBefore`, the work
host appends its vaults, and `personal` stays the default workspace.
