{ ... }:

{
    programs.quickshell = {
        enable = true;
        configs = {
            "shell.qml" = ./shell.qml;
            "Colors.qml" = ./Colors.qml;
        };
    };

    home.file.".config/quickshell/services" = {
        source = ./services;
        recursive = true;
    };

    home.file.".config/quickshell/components" = {
        source = ./components;
        recursive = true;
    };

    home.file.".config/quickshell/containers" = {
        source = ./containers;
        recursive = true;
    };

    # this is the build location, so running qs
    # generates the needed lsp information
    # then it needs to be symlinked to in the repo
    home.file.".config/quickshell/.qmlls.ini" = {
        text = "";
        force = true;
    };
}
