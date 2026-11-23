{ pkgs, ... }:

{
    programs.zsh = {
        enable = true;
        defaultKeymap = "vicmd";
        enableCompletion = true;
        oh-my-zsh = {
            enable = true;
            plugins = [ "git" "rust" "npm" "fzf" "mvn" "ng" "node" "ssh" "docker" "docker-compose" "kubectl"];
            theme = "fwalch";
        };

        shellAliases = {
            c = "clear";
            cd = "z";
            cliphis = "history | fzf | cut -d ' ' -f 2- | clip.exe";
            p = "xclip -o";

            # alias to count all open inotify watchers
            watchercount = "lsof | rg inotify | wc -l";

            # cache cleans
            npmcc="npm cache clean -f";
            ngcc="ng cache clean";
            cc="npm cache clean -f && ng cache clean";

            # eclipse clean
            ec="mvn clean eclipse:clean eclipse:eclipse";

            # --sudo used as ssh keys are configured for the user.
            # Using sudo to run as the root meant losing the keys which access
            # the private repo where the certs are hosted
            update = "cd ~/github_repos/home-nixos && nixos-rebuild switch --flake .#daniel --sudo";
            switch = "nixos-rebuild switch --flake .#daniel --sudo";

            latest_tag = "git tag --sort=creatordate | tail -n 1";

            delete_node_modules="cd ~/github_repos && fd -d 2 -t d | rg node_modules | xargs rm -rf";
            delete_old_nix_generations="sudo nix-env --delete-generations -p /nix/var/nix/profiles/system 5d";

            # open a nix shell with zsh
            nix-shell = "nix-shell --command $SHELL";
            semrel-test="npx semantic-release --dry-run --branch $(git branch --show-current) --no-ci --debug";
            semrel-install="npm i -D @semantic-release/gitlab @semantic-release/git @semantic-release/changelog @semantic-release/exec semantic-release";

            ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
            source-color="matugen image ~/Pictures/wallpapers/vagabond-water.jpg --source-color-index 1 --show-colors";

            # claude aliases
            cca = "claude --permission-mode auto";
            ccp = "claude --permission-mode plan";
            cr = "claude --resume";

            find="fd";
        };

        profileExtra = ''
            # ignore dist directories
            export _ZO_EXCLUDE_DIRS="dist/*"
        '';

        loginExtra = ''
            if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
                start-hyprland
            fi
            tmux source ~/.config/tmux/tmux.conf
        '';

        initContent = ''
            extract_secret() {
                sops decrypt /home/daniel/github_repos/home-nixos/home/sops/home.yaml | yq $1 | tr -d '"' | clip.exe
            }

            nix-show-drv() {
                nix derivation show "$1" | jq '.[].[].structuredAttrs | {url, rev}'
            }

            prefetch-specified-git() {
                nix run nixpkgs#nix-prefetch-git -- --url "$1" --rev "$2" --fetch-submodules
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
        '';

        sessionVariables = {
            SOPS_AGE_KEY_FILE = "/home/daniel/.config/sops/age/keys.txt";
            NODE_PATH="~/.npm/bin";
            QMLLS_BUILD_DIRS = "${pkgs.quickshell}/bin";
            CARGO_HOME="/home/daniel/.cargo";
            PATH="$PATH:/home/daniel/.cargo/bin";
        };
    };
}
