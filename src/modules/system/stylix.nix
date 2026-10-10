{
  extraLib,
  lib,
  config,
  ...
} @ args: let
  hasDesktop = extraLib.hosts.hasDesktop config;
in
extraLib.modules.mkModule args {
  name = "system.stylix";
  hasGui = false;
  cliConfig = {
    stylix = {
      enable = true;
      autoEnable = true;
      polarity = "dark";

      base16Scheme = {
        base00 = "191724";
        base01 = "1f1d2e";
        base02 = "26233a";
        base03 = "6e6a86";
        base04 = "908caa";
        base05 = "e0def4";
        base06 = "e0def4";
        base07 = "524f67";
        base08 = "eb6f92";
        base09 = "f6c177";
        base0A = "ebbcba";
        base0B = "31748f";
        base0C = "9ccfd8";
        base0D = "c4a7e7";
        base0E = "f6c177";
        base0F = "524f67";
      };

      opacity = {
        applications = 1.0;
        desktop = 1.0;
        terminal = 0.8;
        popups = 0.7;
      };

      # Disable GUI and font targets on headless profiles (e.g. WSL), enabled when hasDesktop is true
      targets = {
        gtk.enable = hasDesktop;
        qt.enable = hasDesktop;
        font-packages.enable = hasDesktop;
        fontconfig.enable = hasDesktop;
      };
    };

    # --- Home Manager Targets Synchronization ---
    # Stylix HM modules enable GUI targets by default; synchronize with desktop availability
    home-manager.sharedModules = [
      {
        stylix.targets = {
          gtk.enable = hasDesktop;
          qt.enable = hasDesktop;
          font-packages.enable = hasDesktop;
        };
      }
    ];
  };
}
