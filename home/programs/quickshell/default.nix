{ ... }:

{
    programs.quickshell = {
        enable = true;
        configs = {
            "shell.qml" = ./shell.qml;
        };
    };

    home.file.".config/quickshell/modules" = {
        source = ./modules;
        recursive = true;
    };
}
