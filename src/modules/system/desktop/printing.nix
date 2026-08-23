{
  extraLib,
  pkgs,
  ...
} @ args:
extraLib.modules.mkModule args {
  name = "system.desktop.printing";
  hasGui = false;
  cliConfig = {
    # --- Printing Services ---
    # NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup'
    services.printing = {
      enable = true;
      drivers = [pkgs.hplipWithPlugin];
    };

    # --- Scanner (SANE) Support ---
    hardware.sane = {
      enable = true;
      extraBackends = [pkgs.sane-airscan];
      disabledDefaultBackends = ["escl"];
    };

    environment.systemPackages = [pkgs.hplip];
  };
}
