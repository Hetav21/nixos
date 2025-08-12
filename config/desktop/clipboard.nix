{pkgs, ...}: {
  services.cliphist = {
    enable = true;
    package = pkgs.cliphist;
    allowImages = true;
    systemdTargets = ["hyprland-session.target"];
    extraOptions = ["-max-dedupe-search" "10" "-max-items" "500"];
  };
}
