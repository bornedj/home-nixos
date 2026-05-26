{ pkgs, zen-browser, hyprland, ... }:

{
    # environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];
    environment.systemPackages = [
        pkgs.ghostty
        zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
        # pkgs.kdePackages.qtwayland
        # pkgs.libsForQt5.qt5.qtwayland
        # pkgs.hyprpolkitagent
    ];

    # home.packages = with pkgs; [
    #   pipewire
    # ];

    # programs.hyprland = {
    #     enable = true;
    # };
    wayland.windowManager.hyprland = {
        enable = true;
        package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    fonts.packages = with pkgs; [
        nerd-fonts.hack
    ];

}
