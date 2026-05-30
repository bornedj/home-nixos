{ inputs, ... }:
{
    imports = [
        inputs.matugen.nixosModules.default
    ];

    programs.matugen = {
        variant = "dark";
        wallpaper = "~/Pictures/wallpapers/vagabond-water.jpg";
        jsonFormat = "hex";

        templates = {
            ghostty = {
                input_path = "~/.config/matugen/templates/musashi.ghostty";
                output_path = "~/.config/ghostty/themes/musashi.ghostty";
            };
        };
    };

    home.file.".config/matugen" = {
        source = ./modules;
        recursive = true;
    };
}
