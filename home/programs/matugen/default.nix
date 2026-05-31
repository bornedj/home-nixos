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
            };
            nvim = {
                input_path = ./templates/colors.lua;
                output_path = "~/.config/colors.lua";
            };
            dotbar = {
                input_path = ./templates/statusbar.conf;
                output_path = "~/.config/statusbar.conf";
                post_hook = "tmux source ~/.config/tmux/tmux.conf";
            };
            quickshell = {
                input_path = ./templates/Colors.qml;
                output_path = "~/.config/Colors.qml";
            };
        };
    };
    home.file.".config/ghostty/themes/musashi".source = "${config.programs.matugen.theme.files}/.config/ghostty/themes/musashi";
    home.file.".config/nvim/lua/colors.lua".source = "${config.programs.matugen.theme.files}/.config/colors.lua";
    home.file.".config/tmux/statusbar.conf".source = "${config.programs.matugen.theme.files}/.config/statusbar.conf";
    home.file.".config/quickshell/Colors.qml".source = "${config.programs.matugen.theme.files}/.config/Colors.qml";
}
