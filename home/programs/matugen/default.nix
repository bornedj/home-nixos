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
                input_path = ./modules/templates/musashi.ghostty;
                output_path = "~/.config/ghostty/themes/musashi.ghostty";
            };
        };
    };
    home.file.".config/ghostty/themes/musashi.ghostty".source = "${config.programs.matugen.theme.files}/.config/ghostty/themes/musashi.ghostty";
}
