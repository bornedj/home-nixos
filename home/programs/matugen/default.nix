{ inputs, config, ... }:
{
    imports = [
        inputs.matugen.nixosModules.default
    ];

    programs.matugen = {
        variant = "dark";
        wallpaper = ./../hyprland/wallpapers/vagabond-water.jpg;
        jsonFormat = "hex";
        source_color_index = 1;

        templates = {
            ghostty = {
                input_path = ./templates/musashi;
                output_path = "~/.config/ghostty/themes/musashi";
                post_hook = "pkill -SIGUSR2 ghostty";
            };
            nvim = {
                input_path = ./templates/nvim-colors.lua;
                output_path = "~/.config/matugen.lua";
                post_hook = "pkill -SIGUSR1 nvim";
            };
            tmux = {
                input_path = ./templates/tmux-colors.conf;
                output_path = "~/.config/tmux-colors.conf";
                post_hook = "tmux source ~/.config/tmux/tmux-colors.conf";
            };
            quickshell = {
                input_path = ./templates/quickshell.json;
                output_path = "~/.config/quickshell.json";
            };
        };
    };
    home.file.".config/ghostty/themes/musashi".source = "${config.programs.matugen.theme.files}/.config/ghostty/themes/musashi";
    home.file.".config/nvim/lua/matugen.lua".source = "${config.programs.matugen.theme.files}/.config/matugen.lua";
    home.file.".config/tmux/tmux-colors.conf".source = "${config.programs.matugen.theme.files}/.config/tmux-colors.conf";
    home.file.".local/state/quickshell/generated/colors.json".source = "${config.programs.matugen.theme.files}/.config/quickshell.json";
}
