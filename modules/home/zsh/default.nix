{
  config,
  lib,
  ...
}:
let
  cfg = config.bornedj.zsh;
  inherit (config.bornedj) flake workspace;
in
{
  imports = [ ../options.nix ];

  options.bornedj.zsh = {
    enable = lib.mkEnableOption "the shared zsh configuration";
    generationRetention = lib.mkOption {
      type = lib.types.str;
      default = "1d";
      description = "Age of system generations kept by delete_old_nix_generations.";
    };
    secretsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "sops file that extract_secret reads from. The function is only defined when this is set.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "rust"
          "npm"
          "fzf"
          "mvn"
          "ng"
          "node"
          "ssh"
          "docker"
          "docker-compose"
          "kubectl"
        ];
        theme = lib.mkDefault "cloud";
      };

      shellAliases = {
        c = "clear";
        cd = "z";
        cliphis = "history | fzf | cut -d ' ' -f 2- | ${workspace.clipboardCommand}";
        p = "xclip -o";

        # alias to count all open inotify watchers
        watchercount = "lsof | rg inotify | wc -l";

        # cache cleans
        npmcc = "npm cache clean -f";
        ngcc = "ng cache clean";
        cc = "npm cache clean -f && ng cache clean";

        # eclipse clean
        ec = "mvn clean eclipse:clean eclipse:eclipse";

        # --sudo used as ssh keys are configured for the user.
        # Using sudo to run as the root meant losing the keys which access
        # the private repo where the certs are hosted
        update = "cd ${flake.dir} && nixos-rebuild switch --flake .#${flake.host} --sudo";
        switch = "nixos-rebuild switch --flake .#${flake.host} --sudo";

        latest_tag = "git tag --sort=creatordate | tail -n 1";

        # storage cleanup
        delete_node_modules = "cd ${workspace.reposDir} && fd -d 2 -t d | rg node_modules | xargs rm -rf";
        delete_old_nix_generations = "sudo nix-env --delete-generations -p /nix/var/nix/profiles/system ${cfg.generationRetention}";

        # open a nix shell with zsh
        nix-shell = "nix-shell --command $SHELL";
        semrel-test = "npx semantic-release --dry-run --branch $(git branch --show-current) --no-ci --debug";
        semrel-install = "npm i -D @semantic-release/gitlab @semantic-release/git @semantic-release/changelog @semantic-release/exec semantic-release";

        ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";

        # claude aliases
        cca = "claude --permission-mode auto";
        ccp = "claude --permission-mode plan";
        cr = "claude --resume";

        # rust utils replacements
        find = "fd";
      };

      profileExtra = ''
        # ignore dist directories
        export _ZO_EXCLUDE_DIRS="dist/*"
      '';

      initContent = lib.mkMerge [
        (lib.mkOrder 900 ''
          # Ordered after oh-my-zsh (800) rather than set via defaultKeymap or
          # mkBefore: oh-my-zsh's key-bindings.zsh runs `bindkey -e`, so this
          # has to run after it to win.
          bindkey -v
          # Default 0.4s wait to see if Esc starts a key sequence makes entering
          # vi command mode feel laggy.
          KEYTIMEOUT=1
        '')

        (lib.optionalString (cfg.secretsFile != null) ''
          extract_secret() {
              sops decrypt ${cfg.secretsFile} | yq $1 | tr -d '"' | ${workspace.clipboardCommand}
          }
        '')

        ''
          nix-show-drv() {
              nix derivation show "$1" | jq '.[].[].structuredAttrs | {url, rev}'
          }

          prefetch-specified-git() {
              GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt \
              NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
                $(nix-build '<nixpkgs>' -A nix-prefetch-git --no-out-link 2>/dev/null)/bin/nix-prefetch-git \
                --url "$1" \
                --rev "$2" \
                --fetch-submodules
          }

          # extracts url/rev from a drv and prefetches it in one call
          prefetch-drv() {
              local url rev
              read -r url rev <<< "$(nix derivation show "$1" | jq -r '.[].[].structuredAttrs | "\(.url) \(.rev)"')"
              prefetch-specified-git "$url" "$rev"
          }

          nsi() {
              pkg=$(nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history | awk '{print $2}')
              nix shell nixpkgs#"$pkg"
          }

          eval "$(zoxide init zsh)"
        ''
      ];

      sessionVariables = {
        NODE_PATH = "~/.npm/bin";
        CARGO_HOME = "${config.home.homeDirectory}/.cargo";
      };
    };

    home.sessionPath = [ "${config.home.homeDirectory}/.cargo/bin" ];
  };
}
