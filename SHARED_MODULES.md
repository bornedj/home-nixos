# How the shared home-manager modules work

This flake is the single source of the home-manager config that two
machines share: this one (`.#daniel`, Hyprland desktop) and a work WSL box
whose private flake consumes it as a flake input. This document explains
where shared code goes, how each flake sources it, how the Nix module
system composes the pieces, why the setup is built this way, and how the
Neovim layers load.

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

## How the module system ties it together

### The layers, outside in

1. **The flake** (`flake.nix`) declares inputs (nixpkgs, home-manager,
   sops-nix, ...) and outputs. Two outputs matter here:
   `nixosConfigurations.daniel`, the whole machine, built with
   `nixpkgs.lib.nixosSystem` from a list of NixOS modules; and
   `homeModules`, which is `import ./modules/home`, an attrset of
   home-manager modules other flakes can import.
2. **NixOS** evaluates `nixos/configuration.nix` plus
   `home-manager.nixosModules.home-manager`. That module adds the
   `home-manager.users.<name>` option, and setting
   `home-manager.users.daniel = import ./home/daniel.nix` starts a second,
   nested module evaluation for the user.
3. **home-manager** evaluates `home/daniel.nix` and everything it imports,
   including `self.homeModules.default`. `extraSpecialArgs = { inherit
   inputs self; }` is what makes `self` and `inputs` available as module
   arguments there.
4. **The consumer flake** does the same as step 3, importing
   `inputs.common.homeModules.default` instead of
   `self.homeModules.default`.

### What a module is

A module is a function that takes `{ config, lib, pkgs, ... }` and returns
up to three attributes:

```nix
{ config, lib, ... }:
{
  imports = [ ... ];              # more modules to pull in
  options.bornedj.zsh = { ... };  # the schema: names, types, defaults
  config = { ... };               # values, for any option of any module
}
```

The module system collects every module reachable through `imports`,
merges their `options` into one schema and their `config` into one value
tree, and checks each value against its declared type. The `config`
argument a module receives is that single merged result, not the module's
own piece of it, which is why the zsh module can read
`config.bornedj.flake.dir` even though `home/daniel.nix` set it. Nix is
lazy, so this self-reference works as long as no value depends on itself.

This shape is a convention, not a language feature. Nix is dynamically
typed and has no typeclasses or interfaces; a module is an ordinary
function or attrset. `lib.evalModules` (in nixpkgs' `lib/modules.nix`)
enforces the convention at evaluation time:

- It accepts a module as a path, an attrset or a function. For a function
  calls it with the full set of module arguments (`config`, `lib`,
  `options`, plus anything from `specialArgs`), and uses
  `builtins.functionArgs` to look up any other declared name, such as
  `pkgs`, in `_module.args`. Every named parameter is therefore supplied,
  and the `...` is what lets a module accept the ones it does not name.
- It checks the returned attrset's keys. When a module has an `options`
  or `config` key, only those, `imports` and a few internal keys such as
  `_file` and `disabledModules` are allowed, and any other key is an
  error. A module with neither is treated as all `config`, which is why
  host files like `home/daniel.nix` can set `programs.zsh...` at the top
  level.
- Option types (`lib.types.str`, `listOf`, `submodule`, ...) are a type
  system written in Nix itself: each type is an attrset with a `check`
  function and a `merge` function, run when values are merged. A wrong
  value is an evaluation error with the option path in it, not a
  compile-time error.

The closest analogy is duck typing against a documented protocol.

### How the `bornedj.*` tree is built

Options exist as soon as a module declares them; there is no central
registry. `bornedj` is this repo's namespace, so every shared option reads
`config.bornedj.<program>.<option>`, next to home-manager's own options
(`config.programs.zsh`, `config.home.packages`) in the same tree.

- `modules/home/options.nix` declares the host facts every program needs:
  `bornedj.flake.{dir,host}` and
  `bornedj.workspace.{reposDir,clipboardCommand}`.
- Each program module declares its own subtree, for example
  `options.bornedj.zsh = { enable; generationRetention; secretsFile; }`.
- `modules/home/default.nix` exports each module on its own
  (`homeModules.zsh`, ...) and `default`, which imports them all.

A module that reads the host facts imports `../options.nix` itself
(today only zsh does), so every `homeModules.<program>` also works on its
own; imports are deduplicated by path, so the repeat in `default` is
harmless. Inside a module the usual idiom is
`cfg = config.bornedj.zsh;` in a `let`, and the body reads `cfg.enable`.

### The `lib.mk*` functions

Declaring options:

- `mkOption { type; default; description; }` declares one option. The
  type decides how several definitions merge: `str` allows one (two
  different values are an error), `lines` concatenates with newlines (the
  shared `CLAUDE.md` plus a host section), `listOf` concatenates, `attrsOf`
  merges keys, `nullOr str` allows `null` as "not set" (`extract_secret`
  only exists when `zsh.secretsFile` is set), and `submodule` is a nested
  option set (each entry of `tmux.sessions`).
- `mkEnableOption "..."` is a boolean option defaulting to `false`. Every
  program's `enable` uses it, so importing the modules changes nothing
  until a host opts in.

Setting values conditionally:

- `mkIf cond { ... }` applies a block only when `cond` holds. Every
  module's body is `config = lib.mkIf cfg.enable { ... }`. A plain `if`
  would not work here: it forces `cfg.enable` while the module system is
  still collecting definitions and recurses forever. `mkIf` is deferred.
- `mkMerge [ a b ]` combines several blocks, typically unconditional and
  `mkIf` parts. The nvim module is a `mkMerge` of the core and one `mkIf`
  block per layer.

Priorities, when two modules set the same single-valued option (lower
number wins):

- A plain assignment is priority 100.
- `mkDefault x` is 1000. The shared zsh module sets
  `oh-my-zsh.theme = lib.mkDefault "cloud"` and `home/programs/zsh.nix`
  sets `"fwalch"`, which wins with no special syntax. Shared modules use
  it for anything a host is expected to change.
- `mkForce x` is 50, for overriding another module's plain assignment. It
  is a last resort; nothing here needs it.
- An option's `default` is 1500. Any definition replaces it rather than
  merging with it, which is why the agent-config module sets the shared
  `CLAUDE.md` in `config` with `mkBefore` instead of as the option
  default: a default would disappear as soon as a host appended a
  section.

Ordering, for types that concatenate (`lines`, lists): `mkOrder n x` puts
a definition at position `n`, lower first, plain definitions at 1000.
`mkBefore` is `mkOrder 500` and `mkAfter` is `mkOrder 1500`. That is how
init files are assembled from several modules in a known order:

| Option                       | Order | Content                         |
| ---------------------------- | ----- | ------------------------------- |
| `programs.neovim.initLua`    | 200   | home-manager's preamble         |
|                              | 300   | `options.lua`                   |
|                              | 350   | copilot globals                 |
|                              | 400   | host colours                    |
| `programs.zsh.initContent`   | 800   | oh-my-zsh (home-manager)        |
|                              | 900   | vi mode, after `bindkey -e`     |
| `programs.tmux.extraConfig`  | 900   | shared `tmux.conf`              |
|                              | 1000  | host theme, dotbar              |
|                              | 1900  | Claude status inject            |
|                              | 2000  | continuum                       |

The obsidian vaults use `mkBefore` so `personal` stays first and other
hosts' vaults append after it.

### Putting it together

A shared module defines what every host gets, gated by `mkEnableOption`
and soft-set with `mkDefault` where hosts differ. A host turns features on
and adds its own definitions to the same options. The module system
merges them by type: lists and lines concatenate in `mkOrder` order,
attrsets such as `shellAliases` and `programs.git.settings` merge per key,
and single values follow priority. A host's own layer is nothing more
than ordinary definitions on those same options.

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
   shared `options.lua` at 300 (sets `mapleader` and `vim.opt`), the
   copilot globals at 350 when that layer is on, the host's colour script
   at 400. Nothing else goes through `initLua`; no plugin `config` strings
   are used. The copilot globals are here because copilot.vim reads
   `copilot_no_tab_map` while its own `plugin/` file is sourced, and
   `init.lua` is the only stage guaranteed to run before every `plugin/`
   file.

   Colours run here, before any plugin, on purpose: `:colorscheme` clears
   every highlight group, and obsidian.nvim defines its groups only once
   during `setup()`. Running the colourscheme from `after/plugin` wiped
   them. From `init.lua` the colourscheme is in place before any `setup()`
   runs. `require('base16-colorscheme')` and `require('onenord')` resolve
   at this point because Neovim's loader searches start packages before
   `packloadall`.
2. **`plugin/` files** of every start package. The core layer has one
   such file, `plugin/bornedj.lua`, which `require`s the `bornedj.*`
   modules from a list:

   `remap, fugitive, telescope, harpoon, comment, treesitter, trouble,
   devicons, which-key, claude-code, undotree, obsidian, dadbod, lsp, cmp`

   The list order carries no meaning: no module depends on another having
   run. `lsp.lua` sets the cmp capabilities and enables the servers in the
   same file, and servers only start on `FileType`, after startup, so `lsp`
   and `cmp` can come in either order. This is the classic `init.lua` full
   of `require` lines, moved into a plugin file so it runs after
   `init.lua`. Each `require` is wrapped in `xpcall` with a traceback, so
   one failing module (obsidian without its vault directories, say) is
   reported without stopping the rest.

   Optional layers also use `plugin/` files for things that must run at
   this stage: `bornedj-java.lua` adds the `LspAttach` autocmd that attaches
   the buffer-local DAP maps for `jdtls` clients and calls
   `vim.lsp.enable 'jdtls'`; `bornedj-qml.lua` enables `qmlls`;
   `bornedj-wsl.lua` defines the Windows maps (`<leader>gB` for git-bash,
   because telescope owns `<leader>gb`); `bornedj-copilot.lua` maps insert
   `<C-y>` to accept a suggestion. nvim-cmp wraps whatever `<C-y>` map
   exists on the first `InsertEnter` and falls back to it when the
   completion menu is closed, so that map only has to exist by the end of
   startup.
3. **`lsp/<server>.lua` and `after/lsp/<server>.lua`** are read lazily when
   a server is enabled. nvim-lspconfig ships the stock definitions in
   `lsp/`; our per-server settings live in `after/lsp/` (eslint,
   rust_analyzer, lua_ls, emmet_ls, hls, and jdtls / qmlls in their
   layers) because `after/` directories are merged after every `lsp/` on
   the runtimepath, so nvim-lspconfig's values never override ours.
   `lua_ls` reads `generated.lua_libraries`; `jdtls` reads
   `generated.jdtls_cmd` and uses `root_markers` (`pom.xml`, `mvnw`,
   `gradlew`, `.git`).
4. **`after/plugin/` files**, which run after every `plugin/` file. The
   shared layers have none; this stage is for overriding something another
   plugin's `plugin/` file set up. A host layer may use it, as the work
   layer does for its gitlab.vim setup.

`after/queries/markdown/*.scm` in the core layer extend the stock markdown
queries (`; extends`), which the old `initLua` setup never put on the
runtimepath.

The obsidian vault list is built the same way as everything else: the
module defines `personal` and `daily_notes` with `lib.mkBefore`, the work
host appends its vaults, and `personal` stays the default workspace.
