{ inputs, config, ... }:
{
    imports = [
        inputs.matugen.nixosModules.default
    ];

    programs.matugen = {
        variant = "dark";
        wallpaper = ./../hyprland/wallpapers/vagabond-water.jpg;
        jsonFormat = "hex";
        source_color_index = 0;

        templates = {
            ghostty = {
                input_path = ./modules/templates/musashi;
                output_path = "~/.config/ghostty/themes/musashi";
            };
            nvim = {
                input_path = ./modules/templates/colors.lua;
                output_path = "lua/colors.lua";
            };
        };
    };
    home.file.".config/ghostty/themes/musashi".source = "${config.programs.matugen.theme.files}/.config/ghostty/themes/musashi";
    home.file.".config/nvim/lua/colors.lua".source = "${config.programs.matugen.theme.files}/lua/colors.lua";
}
